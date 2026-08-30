import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const supabase = await createClient();
  const { searchParams } = new URL(request.url);
  const type = searchParams.get('type');
  const difficulty = searchParams.get('difficulty');
  const phase = searchParams.get('phase');
  const isFree = searchParams.get('free');
  const q = searchParams.get('q');

  let query = supabase.from('resources').select('*, day_resources(day_id)');

  if (type) query = query.eq('type', type);
  if (difficulty) query = query.eq('difficulty', difficulty);
  if (isFree !== null) query = query.eq('is_free', isFree === 'true');
  if (q) query = query.ilike('title', `%${q}%`);

  const { data, error } = await query.order('title');
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  // Get user bookmarks if authenticated
  const { data: { user } } = await supabase.auth.getUser();
  if (user) {
    const { data: bookmarks } = await supabase
      .from('bookmarks')
      .select('resource_id')
      .eq('user_id', user.id);

    const bookmarkSet = new Set((bookmarks || []).map(b => b.resource_id));
    const resourcesWithBookmarks = (data || []).map(r => ({
      ...r,
      day_ids: (r.day_resources || []).map((dr: { day_id: number }) => dr.day_id),
      is_bookmarked: bookmarkSet.has(r.id),
    }));

    return NextResponse.json(resourcesWithBookmarks);
  }

  return NextResponse.json((data || []).map(r => ({
    ...r,
    day_ids: (r.day_resources || []).map((dr: { day_id: number }) => dr.day_id),
    is_bookmarked: false,
  })));
}
