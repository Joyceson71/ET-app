import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import { z } from 'zod';
import DOMPurify from 'isomorphic-dompurify';

const noteSchema = z.object({
  day_id: z.number().int().min(1).max(120).optional(),
  content: z.string().max(50000),
});

export async function GET(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { searchParams } = new URL(request.url);
  const q = searchParams.get('q');
  const dayId = searchParams.get('day_id');

  let query = supabase
    .from('notes')
    .select('*')
    .eq('user_id', user.id)
    .order('updated_at', { ascending: false });

  if (q) query = query.ilike('content', `%${q}%`);
  if (dayId) query = query.eq('day_id', parseInt(dayId));

  const { data, error } = await query;
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json(data);
}

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const body = await request.json();
  const parsed = noteSchema.safeParse(body);
  if (!parsed.success) return NextResponse.json({ error: 'Invalid request' }, { status: 400 });

  // Sanitize content to prevent XSS
  const sanitized = DOMPurify.sanitize(parsed.data.content);

  const { data, error } = await supabase
    .from('notes')
    .upsert({
      user_id: user.id,
      day_id: parsed.data.day_id,
      content: sanitized,
    }, { onConflict: 'user_id,day_id' })
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json(data);
}
