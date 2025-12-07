import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Video, Plus } from "lucide-react";
import Link from "next/link";

export default function VideosPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-4xl font-bold tracking-tight">My Videos</h1>
          <p className="text-muted-foreground mt-1">
            View, download, and manage your rendered videos
          </p>
        </div>
        <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
          <Link href="/create">
            <Plus className="mr-2 h-4 w-4" />
            Create Video
          </Link>
        </Button>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="all" className="space-y-4">
        <TabsList className="bg-white/[0.03] border border-white/[0.08]">
          <TabsTrigger value="all" className="data-[state=active]:bg-white/[0.08]">All Videos</TabsTrigger>
          <TabsTrigger value="completed" className="data-[state=active]:bg-white/[0.08]">Completed</TabsTrigger>
          <TabsTrigger value="processing" className="data-[state=active]:bg-white/[0.08]">Processing</TabsTrigger>
          <TabsTrigger value="failed" className="data-[state=active]:bg-white/[0.08]">Failed</TabsTrigger>
        </TabsList>

        <TabsContent value="all">
          <Card className="border-white/[0.08] bg-transparent">
            <CardContent className="flex flex-col items-center justify-center py-20 text-center">
              <div className="flex h-20 w-20 items-center justify-center rounded-2xl bg-white/[0.03] mb-6">
                <Video className="h-10 w-10 text-muted-foreground" />
              </div>
              <h3 className="text-2xl font-semibold mb-2">No videos yet</h3>
              <p className="text-muted-foreground mb-8 max-w-md">
                Your rendered videos will appear here. Create your first video to get started.
              </p>
              <Button asChild className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
                <Link href="/create">
                  <Plus className="mr-2 h-4 w-4" />
                  Create First Video
                </Link>
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="completed">
          <Card className="border-white/[0.08] bg-transparent">
            <CardContent className="py-12 text-center text-muted-foreground">
              No completed videos
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="processing">
          <Card className="border-white/[0.08] bg-transparent">
            <CardContent className="py-12 text-center text-muted-foreground">
              No videos processing
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="failed">
          <Card className="border-white/[0.08] bg-transparent">
            <CardContent className="py-12 text-center text-muted-foreground">
              No failed videos
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
