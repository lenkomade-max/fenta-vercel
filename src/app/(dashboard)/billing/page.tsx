import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Check, Sparkles, Zap, Crown } from "lucide-react";

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
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Billing</h1>
        <p className="text-muted-foreground">
          Manage your subscription and usage
        </p>
      </div>

      {/* Current Usage */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Current Plan</CardTitle>
              <CardDescription>Free Plan</CardDescription>
            </div>
            <Badge>Free</Badge>
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-4">
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>Videos (0/10)</span>
                <span className="text-muted-foreground">0%</span>
              </div>
              <Progress value={0} />
            </div>
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>Render Time (0s/300s)</span>
                <span className="text-muted-foreground">0%</span>
              </div>
              <Progress value={0} />
            </div>
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>AI Credits (50/50)</span>
                <span className="text-muted-foreground">100%</span>
              </div>
              <Progress value={100} />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Plans */}
      <div>
        <h2 className="text-xl font-semibold mb-4">Available Plans</h2>
        <div className="grid gap-4 md:grid-cols-3">
          {plans.map((plan) => (
            <Card
              key={plan.name}
              className={plan.popular ? "border-primary" : ""}
            >
              <CardHeader>
                {plan.popular && (
                  <Badge className="w-fit mb-2">Most Popular</Badge>
                )}
                <CardTitle className="flex items-center gap-2">
                  {plan.name}
                  {plan.name === "Pro" && <Crown className="h-4 w-4 text-yellow-500" />}
                </CardTitle>
                <div className="flex items-baseline gap-1">
                  <span className="text-3xl font-bold">{plan.price}</span>
                  <span className="text-muted-foreground">/month</span>
                </div>
                <CardDescription>{plan.description}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <ul className="space-y-2 text-sm">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex items-center gap-2">
                      <Check className="h-4 w-4 text-primary" />
                      {feature}
                    </li>
                  ))}
                </ul>
                <Button
                  className="w-full"
                  variant={plan.current ? "outline" : "default"}
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
