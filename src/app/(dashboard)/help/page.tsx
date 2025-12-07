import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Book,
  MessageCircle,
  Mail,
  ExternalLink,
  PlayCircle,
  FileQuestion,
  Zap
} from "lucide-react";

const resources = [
  {
    title: "Getting Started",
    description: "Learn the basics of creating videos with Fenta",
    icon: PlayCircle,
    iconColor: "text-green-400",
    bgColor: "bg-green-500/10",
  },
  {
    title: "Documentation",
    description: "Detailed guides and API reference",
    icon: Book,
    iconColor: "text-blue-400",
    bgColor: "bg-blue-500/10",
  },
  {
    title: "FAQ",
    description: "Frequently asked questions",
    icon: FileQuestion,
    iconColor: "text-purple-400",
    bgColor: "bg-purple-500/10",
  },
  {
    title: "Workflow Guide",
    description: "Master the workflow builder",
    icon: Zap,
    iconColor: "text-[#C9F73A]",
    bgColor: "bg-[#C9F73A]/10",
  },
];

export default function HelpPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      <div>
        <h1 className="text-4xl font-bold tracking-tight">Help & Support</h1>
        <p className="text-muted-foreground mt-1">
          Get help with Fenta or contact our support team
        </p>
      </div>

      {/* Resources */}
      <div className="grid gap-4 md:grid-cols-2 animate-stagger">
        {resources.map((resource) => (
          <Card
            key={resource.title}
            className="border-white/[0.08] bg-transparent hover:border-[#C9F73A]/40 hover:shadow-[0_0_20px_rgba(201,247,58,0.08)] transition-all cursor-pointer group"
          >
            <CardHeader>
              <div className="flex items-start gap-4">
                <div className={`flex h-11 w-11 items-center justify-center rounded-xl ${resource.bgColor} group-hover:scale-110 transition-transform`}>
                  <resource.icon className={`h-5 w-5 ${resource.iconColor}`} />
                </div>
                <div className="flex-1">
                  <CardTitle className="text-base flex items-center gap-2">
                    {resource.title}
                    <ExternalLink className="h-3 w-3 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
                  </CardTitle>
                  <CardDescription className="mt-1">{resource.description}</CardDescription>
                </div>
              </div>
            </CardHeader>
          </Card>
        ))}
      </div>

      {/* Contact */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardHeader>
          <CardTitle>Contact Support</CardTitle>
          <CardDescription>
            Can&apos;t find what you&apos;re looking for? Reach out to us.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex gap-3">
          <Button variant="outline" className="border-white/[0.15] hover:bg-white/[0.05] hover:border-white/25">
            <Mail className="mr-2 h-4 w-4" />
            Email Support
          </Button>
          <Button variant="outline" className="border-white/[0.15] hover:bg-white/[0.05] hover:border-white/25">
            <MessageCircle className="mr-2 h-4 w-4" />
            Discord Community
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
