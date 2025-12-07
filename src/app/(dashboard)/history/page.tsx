import { Card, CardContent } from "@/components/ui/card";
import { Clock } from "lucide-react";

export default function HistoryPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      <div>
        <h1 className="text-4xl font-bold tracking-tight">History</h1>
        <p className="text-muted-foreground mt-1">
          Your video creation activity log
        </p>
      </div>

      <Card className="border-white/[0.08] bg-transparent">
        <CardContent className="flex flex-col items-center justify-center py-20 text-center">
          <div className="flex h-20 w-20 items-center justify-center rounded-2xl bg-white/[0.03] mb-6">
            <Clock className="h-10 w-10 text-muted-foreground" />
          </div>
          <h3 className="text-2xl font-semibold mb-2">No activity yet</h3>
          <p className="text-muted-foreground max-w-md">
            Your video creation history will appear here once you start creating videos.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
