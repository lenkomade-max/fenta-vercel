import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Plus, Workflow, Zap } from "lucide-react";
import Link from "next/link";

export default function WorkflowsPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-4xl font-bold tracking-tight">Workflows</h1>
          <p className="text-muted-foreground mt-1">
            Build and manage your video creation pipelines
          </p>
        </div>
        <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
          <Link href="/workflows/new">
            <Plus className="mr-2 h-4 w-4" />
            New Workflow
          </Link>
        </Button>
      </div>

      {/* Empty State */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardContent className="flex flex-col items-center justify-center py-20 text-center">
          <div className="flex h-20 w-20 items-center justify-center rounded-2xl bg-[#C9F73A]/10 mb-6">
            <Workflow className="h-10 w-10 text-[#C9F73A]" />
          </div>
          <h3 className="text-2xl font-semibold mb-2">No workflows yet</h3>
          <p className="text-muted-foreground mb-8 max-w-md">
            Create your first workflow to automate video production with custom pipelines
          </p>
          <div className="flex gap-3">
            <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
              <Link href="/workflows/new">
                <Plus className="mr-2 h-4 w-4" />
                Create Workflow
              </Link>
            </Button>
            <Button variant="outline" className="border-white/[0.15] hover:bg-white/[0.05] hover:border-white/25">
              <Zap className="mr-2 h-4 w-4" />
              Use Template
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Info Cards */}
      <div className="grid gap-4 md:grid-cols-3 animate-stagger">
        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader>
            <CardTitle className="text-base">Visual Builder</CardTitle>
            <CardDescription>
              Drag and drop nodes to create video pipelines. Connect inputs to outputs visually.
            </CardDescription>
          </CardHeader>
        </Card>

        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader>
            <CardTitle className="text-base">AI Powered</CardTitle>
            <CardDescription>
              Use AI to generate scripts, find stock footage, create voiceovers, and more.
            </CardDescription>
          </CardHeader>
        </Card>

        <Card className="border-white/[0.08] bg-transparent hover:border-white/20 transition-all">
          <CardHeader>
            <CardTitle className="text-base">Batch Processing</CardTitle>
            <CardDescription>
              Run workflows on schedule or process multiple videos at once.
            </CardDescription>
          </CardHeader>
        </Card>
      </div>
    </div>
  );
}
