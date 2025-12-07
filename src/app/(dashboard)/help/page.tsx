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
import Link from "next/link";

const resources = [
  {
    title: "Getting Started",
    description: "Learn the basics of creating videos with Fenta",
    icon: PlayCircle,
    href: "#",
  },
  {
    title: "Documentation",
    description: "Detailed guides and API reference",
    icon: Book,
    href: "#",
  },
  {
    title: "FAQ",
    description: "Frequently asked questions",
    icon: FileQuestion,
    href: "#",
  },
  {
    title: "Workflow Guide",
    description: "Master the workflow builder",
    icon: Zap,
    href: "#",
  },
];

export default function HelpPage() {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Help & Support</h1>
        <p className="text-muted-foreground">
          Get help with Fenta or contact our support team
        </p>
      </div>

      {/* Resources */}
      <div className="grid gap-4 md:grid-cols-2">
        {resources.map((resource) => (
          <Card key={resource.title} className="hover:border-primary/50 transition-colors">
            <CardHeader>
              <div className="flex items-start gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
                  <resource.icon className="h-5 w-5 text-primary" />
                </div>
                <div className="flex-1">
                  <CardTitle className="text-base flex items-center gap-2">
                    {resource.title}
                    <ExternalLink className="h-3 w-3 text-muted-foreground" />
                  </CardTitle>
                  <CardDescription>{resource.description}</CardDescription>
                </div>
              </div>
            </CardHeader>
          </Card>
        ))}
      </div>

      {/* Contact */}
      <Card>
        <CardHeader>
          <CardTitle>Contact Support</CardTitle>
          <CardDescription>
            Can&apos;t find what you&apos;re looking for? Reach out to us.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex gap-4">
          <Button variant="outline">
            <Mail className="mr-2 h-4 w-4" />
            Email Support
          </Button>
          <Button variant="outline">
            <MessageCircle className="mr-2 h-4 w-4" />
            Discord Community
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
