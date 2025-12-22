  # Fenta Design System

  Based on [Unlimit.com](https://www.unlimit.com/) style — dark theme version.

  ---

  ## Color Palette

  ### Primary Colors
  ```css
  --color-background: #0A0A0A;        /* Pure dark background */
  --color-background-elevated: #111111; /* Cards, modals */
  --color-background-subtle: #1A1A1A;   /* Hover states, secondary bg */

  --color-foreground: #FAFAFA;        /* Primary text */
  --color-foreground-muted: #A1A1A1;  /* Secondary text */
  --color-foreground-subtle: #666666; /* Disabled, hints */
  ```

  ### Accent Colors
  ```css
  --color-accent: #C9F73A;            /* Lime green - PRIMARY ACCENT */
  --color-accent-hover: #D4FF4A;      /* Lighter on hover */
  --color-accent-muted: #C9F73A33;    /* 20% opacity for backgrounds */
  --color-accent-foreground: #0A0A0A; /* Text on accent */
  ```

  ### Semantic Colors
  ```css
  --color-success: #22C55E;
  --color-warning: #F59E0B;
  --color-error: #EF4444;
  --color-info: #3B82F6;
  ```

  ### Border & Dividers
  ```css
  --color-border: rgba(255, 255, 255, 0.1);
  --color-border-hover: rgba(255, 255, 255, 0.2);
  --color-border-accent: #C9F73A;
  ```

  ---

  ## Typography

  ### Font Family
  ```css
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
  ```

  ### Font Sizes (Mobile → Desktop)
  ```css
  --text-xs: 0.75rem;     /* 12px */
  --text-sm: 0.875rem;    /* 14px */
  --text-base: 1rem;      /* 16px */
  --text-lg: 1.125rem;    /* 18px */
  --text-xl: 1.25rem;     /* 20px */
  --text-2xl: 1.5rem;     /* 24px */
  --text-3xl: 1.875rem;   /* 30px */
  --text-4xl: 2.25rem;    /* 36px */
  --text-5xl: 3rem;       /* 48px */
  --text-6xl: 3.75rem;    /* 60px - Hero headlines */
  --text-7xl: 4.5rem;     /* 72px - Large hero */
  ```

  ### Font Weights
  ```css
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;
  ```

  ### Line Heights
  ```css
  --leading-tight: 1.1;   /* Headlines */
  --leading-snug: 1.25;   /* Subheadings */
  --leading-normal: 1.5;  /* Body text */
  --leading-relaxed: 1.75; /* Long-form content */
  ```

  ### Letter Spacing
  ```css
  --tracking-tighter: -0.05em; /* Large headlines */
  --tracking-tight: -0.025em;  /* Headings */
  --tracking-normal: 0;        /* Body */
  --tracking-wide: 0.025em;    /* Small caps, labels */
  ```

  ---

  ## Spacing System

  ```css
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-3: 0.75rem;   /* 12px */
  --space-4: 1rem;      /* 16px */
  --space-5: 1.25rem;   /* 20px */
  --space-6: 1.5rem;    /* 24px */
  --space-8: 2rem;      /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */
  --space-20: 5rem;     /* 80px */
  --space-24: 6rem;     /* 96px */
  --space-32: 8rem;     /* 128px */
  ```

  ---

  ## Border Radius

  ```css
  --radius-none: 0;
  --radius-sm: 0.25rem;   /* 4px - Small elements */
  --radius-md: 0.5rem;    /* 8px - Buttons, inputs */
  --radius-lg: 0.75rem;   /* 12px - Cards */
  --radius-xl: 1rem;      /* 16px - Large cards */
  --radius-2xl: 1.5rem;   /* 24px - Modals */
  --radius-full: 9999px;  /* Pills, avatars */
  ```

  ---

  ## Shadows

  ```css
  /* Subtle elevation */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.5);

  /* Cards */
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.5),
              0 2px 4px -2px rgba(0, 0, 0, 0.5);

  /* Elevated cards, dropdowns */
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.5),
              0 4px 6px -4px rgba(0, 0, 0, 0.5);

  /* Modals */
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.5),
              0 8px 10px -6px rgba(0, 0, 0, 0.5);

  /* Accent glow */
  --shadow-accent: 0 0 20px rgba(201, 247, 58, 0.3);
  --shadow-accent-lg: 0 0 40px rgba(201, 247, 58, 0.4);
  ```

  ---

  ## Animations & Transitions

  ### Timing Functions
  ```css
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
  ```

  ### Durations
  ```css
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
  --duration-slower: 700ms;
  --duration-slowest: 1000ms;
  ```

  ### Standard Transitions
  ```css
  /* Default transition for hover states */
  --transition-colors: color 150ms ease, background-color 150ms ease, border-color 150ms ease;

  /* For transform animations */
  --transition-transform: transform 300ms cubic-bezier(0.4, 0, 0.2, 1);

  /* For opacity changes */
  --transition-opacity: opacity 300ms ease;

  /* All properties */
  --transition-all: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
  ```

  ### Keyframe Animations

  ```css
  /* Fade in */
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  /* Fade in up */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Scale in */
  @keyframes scaleIn {
    from {
      opacity: 0;
      transform: scale(0.95);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }

  /* SVG stroke draw (Unlimit style) */
  @keyframes strokeDraw {
    from {
      stroke-dashoffset: 1000;
    }
    to {
      stroke-dashoffset: 0;
    }
  }

  /* Flicker effect (Unlimit style) */
  @keyframes flicker {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }

  /* Pulse glow */
  @keyframes pulseGlow {
    0%, 100% {
      box-shadow: 0 0 20px rgba(201, 247, 58, 0.3);
    }
    50% {
      box-shadow: 0 0 40px rgba(201, 247, 58, 0.5);
    }
  }

  /* Slide in from right */
  @keyframes slideInRight {
    from {
      opacity: 0;
      transform: translateX(20px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }

  /* Spin */
  @keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  ```

  ---

  ## Component Styles

  ### Buttons

  ```css
  /* Primary Button */
  .btn-primary {
    background: #C9F73A;
    color: #0A0A0A;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 150ms ease;
  }
  .btn-primary:hover {
    background: #D4FF4A;
    box-shadow: 0 0 20px rgba(201, 247, 58, 0.3);
  }

  /* Secondary Button */
  .btn-secondary {
    background: transparent;
    color: #FAFAFA;
    border: 1px solid rgba(255, 255, 255, 0.2);
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 150ms ease;
  }
  .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.05);
    border-color: rgba(255, 255, 255, 0.3);
  }

  /* Ghost Button */
  .btn-ghost {
    background: transparent;
    color: #FAFAFA;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 150ms ease;
  }
  .btn-ghost:hover {
    background: rgba(255, 255, 255, 0.05);
  }
  ```

  ### Cards

  ```css
  .card {
    background: #111111;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 0.75rem;
    padding: 1.5rem;
    transition: all 300ms ease;
  }
  .card:hover {
    border-color: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
  }
  .card-accent:hover {
    border-color: #C9F73A;
    box-shadow: 0 0 20px rgba(201, 247, 58, 0.1);
  }
  ```

  ### Inputs

  ```css
  .input {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 0.5rem;
    padding: 0.75rem 1rem;
    color: #FAFAFA;
    transition: all 150ms ease;
  }
  .input:focus {
    outline: none;
    border-color: #C9F73A;
    box-shadow: 0 0 0 3px rgba(201, 247, 58, 0.1);
  }
  .input::placeholder {
    color: #666666;
  }
  ```

  ### Navigation

  ```css
  .navbar {
    background: rgba(10, 10, 10, 0.8);
    backdrop-filter: blur(12px);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    position: sticky;
    top: 0;
    z-index: 50;
  }
  ```

  ### Sidebar

  ```css
  .sidebar {
    background: #0A0A0A;
    border-right: 1px solid rgba(255, 255, 255, 0.1);
    width: 280px;
  }
  .sidebar-item {
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;
    color: #A1A1A1;
    transition: all 150ms ease;
  }
  .sidebar-item:hover {
    background: rgba(255, 255, 255, 0.05);
    color: #FAFAFA;
  }
  .sidebar-item.active {
    background: rgba(201, 247, 58, 0.1);
    color: #C9F73A;
  }
  ```

  ---

  ## Breakpoints

  ```css
  --screen-sm: 640px;   /* Mobile landscape */
  --screen-md: 768px;   /* Tablet */
  --screen-lg: 1024px;  /* Desktop */
  --screen-xl: 1280px;  /* Large desktop */
  --screen-2xl: 1536px; /* Extra large */
  ```

  ---

  ## Z-Index Scale

  ```css
  --z-dropdown: 1000;
  --z-sticky: 1020;
  --z-fixed: 1030;
  --z-modal-backdrop: 1040;
  --z-modal: 1050;
  --z-popover: 1060;
  --z-tooltip: 1070;
  --z-toast: 1080;
  ```

  ---

  ## Usage Guidelines

  ### Do's
  - Use lime green (`#C9F73A`) sparingly for CTAs and important highlights
  - Maintain high contrast for accessibility (WCAG AA minimum)
  - Use subtle animations (300ms or less for most interactions)
  - Apply consistent spacing using the spacing scale
  - Use card elevation to create visual hierarchy

  ### Don'ts
  - Don't overuse the accent color — it should draw attention
  - Don't use pure white (#FFFFFF) for backgrounds — use #0A0A0A or #111111
  - Don't make animations longer than 500ms for UI interactions
  - Don't use too many font weights — stick to 400, 500, 600
  - Don't forget hover states and focus indicators

  ---

  ## Implementation in Tailwind

  Add to `tailwind.config.ts`:

  ```typescript
  const config = {
    theme: {
      extend: {
        colors: {
          lime: {
            400: '#C9F73A',
            500: '#B8E635',
          },
          dark: {
            900: '#0A0A0A',
            800: '#111111',
            700: '#1A1A1A',
          }
        },
        animation: {
          'fade-in': 'fadeIn 0.5s ease-out',
          'fade-in-up': 'fadeInUp 0.5s ease-out',
          'scale-in': 'scaleIn 0.3s ease-out',
          'stroke-draw': 'strokeDraw 1s ease-in-out forwards',
          'flicker': 'flicker 2s ease-in-out infinite',
          'pulse-glow': 'pulseGlow 2s ease-in-out infinite',
        }
      }
    }
  }
  ```

  ---

  ## Reference

  Inspired by: https://www.unlimit.com/
