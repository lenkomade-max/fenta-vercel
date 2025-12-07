import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function SettingsPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      <div>
        <h1 className="text-4xl font-bold tracking-tight">Settings</h1>
        <p className="text-muted-foreground mt-1">
          Manage your account and preferences
        </p>
      </div>

      {/* Profile */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardHeader>
          <CardTitle>Profile</CardTitle>
          <CardDescription>Your personal information</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label htmlFor="name">Name</Label>
              <Input
                id="name"
                placeholder="Your name"
                className="bg-white/[0.03] border-white/[0.08] focus:border-[#C9F73A] focus:ring-[#C9F73A]/20"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                disabled
                className="bg-white/[0.03] border-white/[0.08]"
              />
            </div>
          </div>
          <Button className="bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)] transition-all">
            Save Changes
          </Button>
        </CardContent>
      </Card>

      {/* API Keys */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardHeader>
          <CardTitle>API Keys</CardTitle>
          <CardDescription>Manage your API access keys</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm text-muted-foreground">
            No API keys created yet. API keys allow you to access Fenta programmatically.
          </p>
          <Button variant="outline" className="border-white/[0.15] hover:bg-white/[0.05] hover:border-white/25">
            Generate API Key
          </Button>
        </CardContent>
      </Card>

      {/* Danger Zone */}
      <Card className="border-red-500/30 bg-transparent">
        <CardHeader>
          <CardTitle className="text-red-400">Danger Zone</CardTitle>
          <CardDescription>Irreversible actions</CardDescription>
        </CardHeader>
        <CardContent>
          <Button variant="destructive" className="bg-red-500/10 text-red-400 border border-red-500/30 hover:bg-red-500/20">
            Delete Account
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
