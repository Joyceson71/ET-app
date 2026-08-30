import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function POST(
  _request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  // Check if bookmarked
  const { data: existing } = await supabase
    .from('bookmarks')
    .select('resource_id')
    .eq('user_id', user.id)
    .eq('resource_id', id)
    .single();

  if (existing) {
    await supabase.from('bookmarks').delete().eq('user_id', user.id).eq('resource_id', id);
    return NextResponse.json({ bookmarked: false });
  } else {
    await supabase.from('bookmarks').insert({ user_id: user.id, resource_id: id });
    return NextResponse.json({ bookmarked: true });
  }
}
