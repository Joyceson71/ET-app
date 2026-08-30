import SkillTreeClient from './SkillTreeClient';

export default function SkillTreePage() {
  return (
    <div className="max-w-7xl mx-auto h-[calc(100vh-8rem)] flex flex-col">
      <div className="mb-6 shrink-0">
        <h1 className="text-2xl font-mono font-bold">Skill Tree</h1>
        <p className="text-text-muted">Interactive map of your cybersecurity expertise. Complete curriculum days to unlock nodes.</p>
      </div>
      
      <div className="flex-1 bg-surface border border-border rounded-lg overflow-hidden relative">
        <SkillTreeClient />
      </div>
    </div>
  );
}
