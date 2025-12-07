import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Plus, Play, Clock, Sparkles, Video, Zap, ArrowRight, TrendingUp } from "lucide-react";
import Link from "next/link";

export default function DashboardPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-4xl font-bold tracking-tight">Dashboard</h1>
          <p className="text-muted-foreground mt-1">
            Create stunning videos with AI
          </p>
        </div>
        <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
          <Link href="/create">
            <Plus className="mr-2 h-4 w-4" />
            Create Video
          </Link>
        </Button>
      </div>

      {/* Stats */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4 animate-stagger">
        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Videos Created</CardTitle>
            <Video className="h-4 w-4 text-[#C9F73A]" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">0</div>
            <p className="text-xs text-muted-foreground mt-1">
              <TrendingUp className="inline h-3 w-3 mr-1" />
              This month
            </p>
          </CardContent>
        </Card>

        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Render Time</CardTitle>
            <Clock className="h-4 w-4 text-[#C9F73A]" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">0<span className="text-lg text-muted-foreground">s</span></div>
            <p className="text-xs text-muted-foreground mt-1">300s available</p>
          </CardContent>
        </Card>

        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">AI Credits</CardTitle>
            <Sparkles className="h-4 w-4 text-[#C9F73A]" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">50</div>
            <p className="text-xs text-muted-foreground mt-1">KAI credits remaining</p>
          </CardContent>
        </Card>

        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Workflows</CardTitle>
            <Zap className="h-4 w-4 text-[#C9F73A]" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">0</div>
            <p className="text-xs text-muted-foreground mt-1">3 slots available</p>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <div>
        <h2 className="text-lg font-semibold mb-4">Quick Actions</h2>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3 animate-stagger">
          <Link href="/create">
            <Card className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/50 hover:shadow-[0_0_20px_rgba(201,247,58,0.1)] transition-all cursor-pointer group">
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-[#C9F73A]/10 group-hover:bg-[#C9F73A]/20 transition-colors">
                    <Plus className="h-5 w-5 text-[#C9F73A]" />
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>
                <CardTitle className="text-base mt-3">Quick Create</CardTitle>
                <CardDescription>Create video from template</CardDescription>
              </CardHeader>
            </Card>
          </Link>

          <Link href="/workflows">
            <Card className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/50 hover:shadow-[0_0_20px_rgba(201,247,58,0.1)] transition-all cursor-pointer group">
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-blue-500/10 group-hover:bg-blue-500/20 transition-colors">
                    <Zap className="h-5 w-5 text-blue-400" />
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>
                <CardTitle className="text-base mt-3">Workflow Builder</CardTitle>
                <CardDescription>Build custom video pipelines</CardDescription>
              </CardHeader>
            </Card>
          </Link>

          <Link href="/videos">
            <Card className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/50 hover:shadow-[0_0_20px_rgba(201,247,58,0.1)] transition-all cursor-pointer group">
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-green-500/10 group-hover:bg-green-500/20 transition-colors">
                    <Play className="h-5 w-5 text-green-400" />
                  </div>
                  <ArrowRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                </div>
                <CardTitle className="text-base mt-3">My Videos</CardTitle>
                <CardDescription>View and download renders</CardDescription>
              </CardHeader>
            </Card>
          </Link>
        </div>
      </div>

      {/* Recent Activity */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardHeader>
          <CardTitle>Recent Activity</CardTitle>
          <CardDescription>Your latest video creation activity</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white/[0.03] mb-5">
              <Video className="h-7 w-7 text-muted-foreground" />
            </div>
            <h3 className="text-xl font-semibold">No videos yet</h3>
            <p className="text-muted-foreground mt-2 mb-6 max-w-sm">
              Create your first AI-powered video in minutes
            </p>
            <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
              <Link href="/create">
                <Sparkles className="mr-2 h-4 w-4" />
                Create First Video
              </Link>
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
