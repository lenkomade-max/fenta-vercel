import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Newspaper,
  Skull,
  Brain,
  TrendingUp,
  Laugh,
  Sparkles,
  Film,
  Mic,
  ArrowRight,
  Wand2,
} from "lucide-react";
import Link from "next/link";

const templates = [
  {
    id: "news",
    title: "News & Facts",
    description: "Breaking news, science facts, tech updates",
    icon: Newspaper,
    gradient: "from-blue-500/20 to-cyan-500/20",
    iconColor: "text-blue-400",
    tags: ["News", "Science", "Tech"],
  },
  {
    id: "crime",
    title: "True Crime",
    description: "Mystery stories, crime investigations",
    icon: Skull,
    gradient: "from-red-500/20 to-orange-500/20",
    iconColor: "text-red-400",
    tags: ["Crime", "Mystery", "Horror"],
  },
  {
    id: "psychology",
    title: "Psychology",
    description: "Mind facts, relationships, self-improvement",
    icon: Brain,
    gradient: "from-purple-500/20 to-pink-500/20",
    iconColor: "text-purple-400",
    tags: ["Psychology", "Dating", "Self-help"],
  },
  {
    id: "finance",
    title: "Finance & Crypto",
    description: "Money tips, investing, crypto news",
    icon: TrendingUp,
    gradient: "from-green-500/20 to-emerald-500/20",
    iconColor: "text-green-400",
    tags: ["Finance", "Crypto", "Investing"],
  },
  {
    id: "entertainment",
    title: "Entertainment",
    description: "Movies, gaming, celebrity gossip",
    icon: Film,
    gradient: "from-yellow-500/20 to-orange-500/20",
    iconColor: "text-yellow-400",
    tags: ["Movies", "Gaming", "Celebrity"],
  },
  {
    id: "humor",
    title: "Humor & Memes",
    description: "Funny stories, fails, viral content",
    icon: Laugh,
    gradient: "from-orange-500/20 to-red-500/20",
    iconColor: "text-orange-400",
    tags: ["Humor", "Memes", "Fails"],
  },
];

export default function CreatePage() {
  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div>
        <h1 className="text-4xl font-bold tracking-tight">Create Video</h1>
        <p className="text-muted-foreground mt-1">
          Choose a template or start from scratch
        </p>
      </div>

      {/* AI Quick Create - Hero Card */}
      <Card className="border-[#C9F73A]/30 bg-gradient-to-br from-[#C9F73A]/5 to-transparent overflow-hidden relative group">
        <div className="absolute inset-0 bg-gradient-to-r from-[#C9F73A]/10 via-transparent to-[#C9F73A]/5 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
        <CardHeader className="pb-4 relative">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#C9F73A] shadow-[0_0_30px_rgba(201,247,58,0.3)] group-hover:shadow-[0_0_40px_rgba(201,247,58,0.5)] transition-all">
                <Wand2 className="h-7 w-7 text-black" />
              </div>
              <div>
                <CardTitle className="text-xl">AI Quick Create</CardTitle>
                <CardDescription className="text-base mt-0.5">
                  Describe your video and let AI do the rest
                </CardDescription>
              </div>
            </div>
            <Button className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
              Try Now
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>
        </CardHeader>
      </Card>

      {/* Templates Grid */}
      <div>
        <h2 className="text-lg font-semibold mb-4">Templates</h2>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3 animate-stagger">
          {templates.map((template) => (
            <Card
              key={template.id}
              className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/40 hover:shadow-[0_0_30px_rgba(201,247,58,0.08)] transition-all cursor-pointer group overflow-hidden"
            >
              <div className={`absolute inset-0 bg-gradient-to-br ${template.gradient} opacity-0 group-hover:opacity-100 transition-opacity duration-300`} />
              <CardHeader className="relative">
                <div className="flex items-start justify-between">
                  <div className={`flex h-11 w-11 items-center justify-center rounded-xl bg-white/[0.05] group-hover:bg-white/[0.08] transition-colors`}>
                    <template.icon className={`h-5 w-5 ${template.iconColor}`} />
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 group-hover:translate-x-1 transition-all" />
                </div>
                <CardTitle className="text-base mt-4">{template.title}</CardTitle>
                <CardDescription>{template.description}</CardDescription>
                <div className="flex flex-wrap gap-1.5 mt-3">
                  {template.tags.map((tag) => (
                    <Badge
                      key={tag}
                      variant="secondary"
                      className="bg-white/[0.05] text-muted-foreground border-0 text-[11px]"
                    >
                      {tag}
                    </Badge>
                  ))}
                </div>
              </CardHeader>
            </Card>
          ))}
        </div>
      </div>

      {/* Advanced Options */}
      <div>
        <h2 className="text-lg font-semibold mb-4">Advanced</h2>
        <div className="grid gap-4 md:grid-cols-2">
          <Link href="/workflows/new">
            <Card className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/40 hover:shadow-[0_0_20px_rgba(201,247,58,0.08)] transition-all cursor-pointer group">
              <CardHeader>
                <div className="flex items-center gap-4">
                  <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-cyan-500/10 group-hover:bg-cyan-500/20 transition-colors">
                    <Sparkles className="h-5 w-5 text-cyan-400" />
                  </div>
                  <div className="flex-1">
                    <CardTitle className="text-base">Workflow Builder</CardTitle>
                    <CardDescription>
                      Build custom video pipelines with nodes
                    </CardDescription>
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>
              </CardHeader>
            </Card>
          </Link>

          <Card className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/40 hover:shadow-[0_0_20px_rgba(201,247,58,0.08)] transition-all cursor-pointer group">
            <CardHeader>
              <div className="flex items-center gap-4">
                <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-pink-500/10 group-hover:bg-pink-500/20 transition-colors">
                  <Mic className="h-5 w-5 text-pink-400" />
                </div>
                <div className="flex-1">
                  <CardTitle className="text-base">Upload Script</CardTitle>
                  <CardDescription>
                    Use your own script or voiceover
                  </CardDescription>
                </div>
                <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
              </div>
            </CardHeader>
          </Card>
        </div>
      </div>
    </div>
  );
}
