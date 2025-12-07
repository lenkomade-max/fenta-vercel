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
  Music,
  Mic,
  ArrowRight
} from "lucide-react";
import Link from "next/link";

const templates = [
  {
    id: "news",
    title: "News & Facts",
    description: "Breaking news, science facts, tech updates",
    icon: Newspaper,
    color: "bg-blue-500/10 text-blue-500",
    tags: ["News", "Science", "Tech"],
  },
  {
    id: "crime",
    title: "True Crime",
    description: "Mystery stories, crime investigations",
    icon: Skull,
    color: "bg-red-500/10 text-red-500",
    tags: ["Crime", "Mystery", "Horror"],
  },
  {
    id: "psychology",
    title: "Psychology",
    description: "Mind facts, relationships, self-improvement",
    icon: Brain,
    color: "bg-purple-500/10 text-purple-500",
    tags: ["Psychology", "Dating", "Self-help"],
  },
  {
    id: "finance",
    title: "Finance & Crypto",
    description: "Money tips, investing, crypto news",
    icon: TrendingUp,
    color: "bg-green-500/10 text-green-500",
    tags: ["Finance", "Crypto", "Investing"],
  },
  {
    id: "entertainment",
    title: "Entertainment",
    description: "Movies, gaming, celebrity gossip",
    icon: Film,
    color: "bg-yellow-500/10 text-yellow-500",
    tags: ["Movies", "Gaming", "Celebrity"],
  },
  {
    id: "humor",
    title: "Humor & Memes",
    description: "Funny stories, fails, viral content",
    icon: Laugh,
    color: "bg-orange-500/10 text-orange-500",
    tags: ["Humor", "Memes", "Fails"],
  },
];

export default function CreatePage() {
  return (
    <div className="space-y-8">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Create Video</h1>
        <p className="text-muted-foreground">
          Choose a template or start from scratch
        </p>
      </div>

      {/* Quick Start */}
      <Card className="border-primary/50 bg-primary/5">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-primary">
                <Sparkles className="h-6 w-6 text-primary-foreground" />
              </div>
              <div>
                <CardTitle>AI Quick Create</CardTitle>
                <CardDescription>
                  Describe your video and let AI do the rest
                </CardDescription>
              </div>
            </div>
            <Button>
              Try Now
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>
        </CardHeader>
      </Card>

      {/* Templates Grid */}
      <div>
        <h2 className="text-xl font-semibold mb-4">Templates</h2>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {templates.map((template) => (
            <Card
              key={template.id}
              className="hover:border-primary/50 transition-colors cursor-pointer group"
            >
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div className={`flex h-10 w-10 items-center justify-center rounded-lg ${template.color}`}>
                    <template.icon className="h-5 w-5" />
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>
                <CardTitle className="text-base mt-3">{template.title}</CardTitle>
                <CardDescription>{template.description}</CardDescription>
                <div className="flex flex-wrap gap-1 mt-2">
                  {template.tags.map((tag) => (
                    <Badge key={tag} variant="secondary" className="text-xs">
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
        <h2 className="text-xl font-semibold mb-4">Advanced</h2>
        <div className="grid gap-4 md:grid-cols-2">
          <Card className="hover:border-primary/50 transition-colors cursor-pointer">
            <Link href="/workflows/new">
              <CardHeader>
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-cyan-500/10">
                    <Sparkles className="h-5 w-5 text-cyan-500" />
                  </div>
                  <div>
                    <CardTitle className="text-base">Workflow Builder</CardTitle>
                    <CardDescription>
                      Build custom video pipelines with nodes
                    </CardDescription>
                  </div>
                </div>
              </CardHeader>
            </Link>
          </Card>

          <Card className="hover:border-primary/50 transition-colors cursor-pointer">
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-pink-500/10">
                  <Mic className="h-5 w-5 text-pink-500" />
                </div>
                <div>
                  <CardTitle className="text-base">Upload Script</CardTitle>
                  <CardDescription>
                    Use your own script or voiceover
                  </CardDescription>
                </div>
              </div>
            </CardHeader>
          </Card>
        </div>
      </div>
    </div>
  );
}
