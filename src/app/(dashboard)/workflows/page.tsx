import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Workflow, Play, MoreHorizontal, Zap } from "lucide-react";
import Link from "next/link";

export default function WorkflowsPage() {
  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Workflows</h1>
          <p className="text-muted-foreground">
            Build and manage your video creation pipelines
          </p>
        </div>
        <Button asChild>
          <Link href="/workflows/new">
            <Plus className="mr-2 h-4 w-4" />
            New Workflow
          </Link>
        </Button>
      </div>

      {/* Empty State */}
      <Card>
        <CardContent className="flex flex-col items-center justify-center py-16 text-center">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 mb-4">
            <Workflow className="h-8 w-8 text-primary" />
          </div>
          <h3 className="text-xl font-semibold mb-2">No workflows yet</h3>
          <p className="text-muted-foreground mb-6 max-w-sm">
            Create your first workflow to automate video production with custom pipelines
          </p>
          <div className="flex gap-3">
            <Button asChild>
              <Link href="/workflows/new">
                <Plus className="mr-2 h-4 w-4" />
                Create Workflow
              </Link>
            </Button>
            <Button variant="outline">
              <Zap className="mr-2 h-4 w-4" />
              Use Template
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Info Cards */}
      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Visual Builder</CardTitle>
            <CardDescription>
              Drag and drop nodes to create video pipelines. Connect inputs to outputs visually.
            </CardDescription>
          </CardHeader>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">AI Powered</CardTitle>
            <CardDescription>
              Use AI to generate scripts, find stock footage, create voiceovers, and more.
            </CardDescription>
          </CardHeader>
        </Card>

        <Card>
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
