"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarGroup,
  SidebarGroupLabel,
  SidebarGroupContent,
} from "@/components/ui/sidebar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import {
  LayoutDashboard,
  Plus,
  Workflow,
  FolderOpen,
  Clock,
  Settings,
  HelpCircle,
  LogOut,
  ChevronUp,
  Zap,
  CreditCard,
  Sparkles,
} from "lucide-react";

const mainNav = [
  { title: "Dashboard", href: "/dashboard", icon: LayoutDashboard },
  { title: "Create Video", href: "/create", icon: Plus, accent: true },
  { title: "Workflows", href: "/workflows", icon: Workflow },
  { title: "My Videos", href: "/videos", icon: FolderOpen },
  { title: "History", href: "/history", icon: Clock },
];

const settingsNav = [
  { title: "Settings", href: "/settings", icon: Settings },
  { title: "Billing", href: "/billing", icon: CreditCard },
  { title: "Help", href: "/help", icon: HelpCircle },
];

export function AppSidebar() {
  const pathname = usePathname();

  return (
    <Sidebar className="border-r border-white/[0.08]">
      <SidebarHeader className="border-b border-white/[0.08] p-4">
        <SidebarMenu>
          <SidebarMenuItem>
            <Link href="/dashboard" className="flex items-center gap-3 group">
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-[#C9F73A] transition-all group-hover:shadow-[0_0_20px_rgba(201,247,58,0.4)]">
                <Zap className="h-5 w-5 text-black" />
              </div>
              <div className="flex flex-col">
                <span className="text-lg font-bold tracking-tight">Fenta</span>
                <span className="text-[10px] uppercase tracking-widest text-muted-foreground">
                  Video AI
                </span>
              </div>
            </Link>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarContent className="px-2 py-4">
        <SidebarGroup>
          <SidebarGroupLabel className="px-3 text-[11px] uppercase tracking-wider text-muted-foreground/70">
            Main
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu className="space-y-1">
              {mainNav.map((item) => {
                const isActive = pathname === item.href;
                return (
                  <SidebarMenuItem key={item.href}>
                    <SidebarMenuButton
                      asChild
                      isActive={isActive}
                      className={`
                        h-10 rounded-lg transition-all duration-200
                        ${isActive
                          ? "bg-[#C9F73A]/10 text-[#C9F73A] font-medium"
                          : "text-muted-foreground hover:bg-white/[0.05] hover:text-foreground"
                        }
                        ${item.accent && !isActive ? "text-[#C9F73A]" : ""}
                      `}
                    >
                      <Link href={item.href} className="flex items-center gap-3">
                        <item.icon className={`h-4 w-4 ${isActive ? "text-[#C9F73A]" : ""}`} />
                        <span>{item.title}</span>
                        {item.accent && !isActive && (
                          <Sparkles className="ml-auto h-3 w-3 text-[#C9F73A]/60" />
                        )}
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup className="mt-6">
          <SidebarGroupLabel className="px-3 text-[11px] uppercase tracking-wider text-muted-foreground/70">
            Account
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu className="space-y-1">
              {settingsNav.map((item) => {
                const isActive = pathname === item.href;
                return (
                  <SidebarMenuItem key={item.href}>
                    <SidebarMenuButton
                      asChild
                      isActive={isActive}
                      className={`
                        h-10 rounded-lg transition-all duration-200
                        ${isActive
                          ? "bg-[#C9F73A]/10 text-[#C9F73A] font-medium"
                          : "text-muted-foreground hover:bg-white/[0.05] hover:text-foreground"
                        }
                      `}
                    >
                      <Link href={item.href} className="flex items-center gap-3">
                        <item.icon className={`h-4 w-4 ${isActive ? "text-[#C9F73A]" : ""}`} />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter className="border-t border-white/[0.08] p-3">
        <SidebarMenu>
          <SidebarMenuItem>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <SidebarMenuButton className="h-auto py-2.5 px-2 hover:bg-white/[0.05] rounded-lg transition-all">
                  <Avatar className="h-8 w-8 ring-2 ring-white/10">
                    <AvatarImage src="/avatar.png" />
                    <AvatarFallback className="bg-[#1A1A1A] text-sm">U</AvatarFallback>
                  </Avatar>
                  <div className="flex flex-col items-start flex-1 ml-2">
                    <span className="font-medium text-sm">User</span>
                    <div className="flex items-center gap-1.5">
                      <Badge
                        variant="secondary"
                        className="h-4 px-1.5 text-[10px] bg-[#C9F73A]/10 text-[#C9F73A] border-0"
                      >
                        Free
                      </Badge>
                    </div>
                  </div>
                  <ChevronUp className="h-4 w-4 text-muted-foreground" />
                </SidebarMenuButton>
              </DropdownMenuTrigger>
              <DropdownMenuContent
                side="top"
                align="start"
                className="w-56 bg-[#111] border-white/10"
              >
                <DropdownMenuItem className="focus:bg-white/[0.05]">
                  <Settings className="mr-2 h-4 w-4" />
                  Settings
                </DropdownMenuItem>
                <DropdownMenuItem className="focus:bg-white/[0.05]">
                  <CreditCard className="mr-2 h-4 w-4" />
                  Upgrade Plan
                </DropdownMenuItem>
                <DropdownMenuSeparator className="bg-white/10" />
                <DropdownMenuItem className="text-red-400 focus:bg-red-500/10 focus:text-red-400">
                  <LogOut className="mr-2 h-4 w-4" />
                  Log out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
    </Sidebar>
  );
}
