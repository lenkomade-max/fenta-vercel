import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Check, Crown } from "lucide-react";

const plans = [
  {
    name: "Free",
    price: "$0",
    description: "For getting started",
    features: [
      "10 videos/month",
      "300s render time",
      "50 AI credits",
      "5 GB storage",
      "3 workflows",
    ],
    current: true,
  },
  {
    name: "Starter",
    price: "$29",
    description: "For creators",
    features: [
      "50 videos/month",
      "1,800s render time",
      "200 AI credits",
      "25 GB storage",
      "10 workflows",
      "Priority support",
    ],
    popular: true,
  },
  {
    name: "Pro",
    price: "$99",
    description: "For professionals",
    features: [
      "Unlimited videos",
      "7,200s render time",
      "1,000 AI credits",
      "100 GB storage",
      "Unlimited workflows",
      "API access",
      "Custom branding",
    ],
  },
];

export default function BillingPage() {
  return (
    <div className="space-y-8 animate-fade-in">
      <div>
        <h1 className="text-4xl font-bold tracking-tight">Billing</h1>
        <p className="text-muted-foreground mt-1">
          Manage your subscription and usage
        </p>
      </div>

      {/* Current Usage */}
      <Card className="border-white/[0.08] bg-transparent">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Current Plan</CardTitle>
              <CardDescription>Free Plan</CardDescription>
            </div>
            <Badge className="bg-[#C9F73A]/10 text-[#C9F73A] border-0">Free</Badge>
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-4">
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>Videos (0/10)</span>
                <span className="text-muted-foreground">0%</span>
              </div>
              <Progress value={0} className="h-2 bg-white/[0.05]" />
            </div>
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>Render Time (0s/300s)</span>
                <span className="text-muted-foreground">0%</span>
              </div>
              <Progress value={0} className="h-2 bg-white/[0.05]" />
            </div>
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>AI Credits (50/50)</span>
                <span className="text-muted-foreground">100%</span>
              </div>
              <Progress value={100} className="h-2 bg-white/[0.05]" />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Plans */}
      <div>
        <h2 className="text-lg font-semibold mb-4">Available Plans</h2>
        <div className="grid gap-4 md:grid-cols-3 animate-stagger">
          {plans.map((plan) => (
            <Card
              key={plan.name}
              className={`border-white/[0.08] bg-transparent transition-all ${
                plan.popular ? "border-[#C9F73A]/50 shadow-[0_0_30px_rgba(201,247,58,0.1)]" : "hover:border-white/20"
              }`}
            >
              <CardHeader>
                {plan.popular && (
                  <Badge className="w-fit mb-2 bg-[#C9F73A] text-black">Most Popular</Badge>
                )}
                <CardTitle className="flex items-center gap-2">
                  {plan.name}
                  {plan.name === "Pro" && <Crown className="h-4 w-4 text-yellow-500" />}
                </CardTitle>
                <div className="flex items-baseline gap-1">
                  <span className="text-4xl font-bold">{plan.price}</span>
                  <span className="text-muted-foreground">/month</span>
                </div>
                <CardDescription>{plan.description}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <ul className="space-y-2.5 text-sm">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex items-center gap-2.5">
                      <div className="flex h-5 w-5 items-center justify-center rounded-full bg-[#C9F73A]/10">
                        <Check className="h-3 w-3 text-[#C9F73A]" />
                      </div>
                      {feature}
                    </li>
                  ))}
                </ul>
                <Button
                  className={`w-full ${
                    plan.current
                      ? "bg-white/[0.05] text-muted-foreground hover:bg-white/[0.08]"
                      : plan.popular
                      ? "bg-[#C9F73A] text-black hover:bg-[#D4FF4A] hover:shadow-[0_0_20px_rgba(201,247,58,0.4)]"
                      : "bg-white/[0.05] hover:bg-white/[0.08]"
                  } transition-all`}
                  disabled={plan.current}
                >
                  {plan.current ? "Current Plan" : "Upgrade"}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}
