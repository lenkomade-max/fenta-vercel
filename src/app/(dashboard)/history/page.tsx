import { Card, CardContent } from "@/components/ui/card";
import { Clock } from "lucide-react";

export default function HistoryPage() {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">History</h1>
        <p className="text-muted-foreground">
          Your video creation activity log
        </p>
      </div>

      <Card>
        <CardContent className="flex flex-col items-center justify-center py-16 text-center">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-muted mb-4">
            <Clock className="h-8 w-8 text-muted-foreground" />
          </div>
          <h3 className="text-xl font-semibold mb-2">No activity yet</h3>
          <p className="text-muted-foreground max-w-sm">
            Your video creation history will appear here once you start creating videos.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
