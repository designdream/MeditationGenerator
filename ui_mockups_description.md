# UI Mockups for Meditation Creation App

## Overview

This document provides detailed descriptions of the user interface mockups for the Meditation Creation App. These mockups represent the key screens and user flows that will deliver the premium, customizable meditation experience outlined in the product requirements and technical specifications.

## Design Philosophy

The UI design follows these core principles:

1. **Elegant Minimalism**: Clean, uncluttered interfaces that promote calm and focus
2. **Intuitive Flow**: Logical progression through the meditation creation process
3. **Premium Feel**: Sophisticated color palette, typography, and animations
4. **Accessibility**: Inclusive design that works for all users
5. **Customization Focus**: Emphasis on user control and personalization

## Color Palette

- **Primary**: Deep Indigo (#3D3A7C) - Represents calm, wisdom, and depth
- **Secondary**: Soft Lavender (#B8B5FF) - Adds warmth and accessibility
- **Accent**: Gentle Teal (#5CBDB9) - Provides contrast and highlights key elements
- **Neutrals**: 
  - Soft White (#F8F7FF) - Background and text areas
  - Light Gray (#E6E6E6) - Subtle separators and inactive elements
  - Dark Gray (#333333) - Primary text
- **Gradients**: Subtle gradients from indigo to purple for backgrounds and key elements

## Typography

- **Primary Font**: Montserrat - Clean, modern sans-serif for headings and UI elements
- **Secondary Font**: Lora - Elegant serif for body text and meditation descriptions
- **Hierarchy**:
  - Headings: Montserrat Bold, 24-32pt
  - Subheadings: Montserrat Medium, 18-22pt
  - Body: Lora Regular, 16pt
  - Captions: Montserrat Light, 14pt

## Key Screens

### 1. Onboarding Screens

#### Welcome Screen
- Full-screen gradient background (indigo to purple)
- App logo centered at top third
- Tagline: "Create your perfect meditation experience"
- "Get Started" button (teal) at bottom
- "Log In" text link below button

#### Personalization Questionnaire
- Series of simple, single-question screens
- Progress indicator at top
- Questions include:
  - "What brings you to meditation?" (Multiple choice)
  - "How experienced are you with meditation?" (Slider)
  - "What outcomes are you seeking?" (Multiple choice)
  - "When do you prefer to meditate?" (Time selection)
- "Next" and "Back" navigation

#### Voice Preference Selection
- Grid of voice options with small play button on each
- Brief sample text for each voice
- Options categorized by gender, accent, and tone
- "Select multiple" instruction at top
- "Continue" button at bottom

#### Music Preference Selection
- Horizontal scrolling categories (Nature, Music, Ambient)
- Vertical list of options within each category
- Play button for each sound
- Volume slider appears when playing
- Multiple selection enabled
- "Continue" button at bottom

### 2. Home Screen

#### Main Layout
- Bottom navigation with 5 icons:
  - Home (selected)
  - Create
  - Library
  - Discover
  - Profile
- Welcome message at top: "Good [morning/afternoon/evening], [Name]"
- Quick stats card showing streak and total meditation time
- "Continue where you left off" section with last meditation

#### Quick Create Section
- Prominent "Create New Meditation" button
- Below it, 3-4 template cards based on user preferences:
  - "Sleep Better Tonight" (8 min)
  - "Morning Calm" (5 min)
  - "Stress Relief" (10 min)
  - "Quick Reset" (3 min)

#### Recent Activity
- Horizontal scrolling list of recently played meditations
- Each card shows:
  - Meditation name
  - Duration
  - Last played date
  - Small play button

### 3. Meditation Creation Flow

#### Step 1: Choose Purpose
- Header: "What's your focus today?"
- Grid of purpose cards with icons:
  - Sleep
  - Stress Relief
  - Focus
  - Anxiety
  - Gratitude
  - Self-Love
  - Energy
  - Manifestation
- "Custom" option at bottom
- "Next" button becomes active after selection

#### Step 2: Select Voice
- Header: "Choose your guide"
- Horizontal list of voice options with circular avatars
- Play button on each to hear sample
- Voice characteristics listed below each (Calm, Energetic, Soothing, etc.)
- Speed/pace adjustment slider
- Volume slider
- "Next" button at bottom

#### Step 3: Choose Sounds
- Header: "Select your soundscape"
- Categories at top (Nature, Music, Ambient, None)
- Grid of sound options with waveform visualization
- Play button on each
- "Add another sound" option (up to 3 layers)
- Layer management with individual volume controls
- "Next" button at bottom

#### Step 4: Customize Content
- Header: "Customize your experience"
- Duration slider (1-60 minutes)
- Guidance level selector (Minimal, Moderate, Detailed)
- Toggle options:
  - Include introduction
  - Include body scan
  - Include silence periods
  - Include closing gratitude
- Advanced options (expandable):
  - Silence period duration
  - Breathing pace
  - Background volume during guidance
- "Preview" and "Create" buttons at bottom

#### Preview Screen
- Minimalist player interface
- Large circular progress indicator
- Meditation name at top (editable)
- Playback controls (play/pause, forward 15s, back 15s)
- Timeline scrubber
- "Save" and "Edit" buttons
- Option to add to favorites

### 4. Library Screen

#### Main Layout
- Search bar at top
- Filter/sort options below search
- Toggle between grid and list views
- "Created by You" and "Favorites" tabs

#### Meditation Cards
- Each card shows:
  - Meditation name
  - Duration
  - Purpose icon
  - Preview of voice and sounds used
  - Last played date (if applicable)
  - Options menu (three dots)

#### Collection Management
- "Create Collection" button
- Drag and drop interface for organizing
- Batch selection mode
- Sort options (date, duration, most played)

### 5. Profile & Settings

#### Profile Overview
- User avatar and name at top
- Subscription status with "Manage" button
- Statistics dashboard:
  - Total meditation time
  - Current streak
  - Longest streak
  - Sessions completed
  - Average session length

#### Settings Sections
- Account Settings
  - Profile information
  - Password and security
  - Notifications
- App Preferences
  - Theme (Light/Dark/System)
  - Download settings
  - Audio quality
- Subscription
  - Current plan
  - Billing information
  - Plan options
- Help & Support
  - FAQ
  - Contact support
  - Tutorial videos

### 6. Playback Screen

#### Minimalist Player
- Large background gradient that subtly animates
- Meditation name in elegant typography
- Circular progress indicator (large, centered)
- Current time / total time
- Playback controls:
  - Back 15 seconds
  - Play/Pause (larger than other controls)
  - Forward 15 seconds
- Volume control (expandable)
- Sleep timer button
- Minimize player button
- Option to add notes after completion

#### Expanded Player Options
- Swipe up to reveal:
  - Detailed timeline with chapter markers
  - Playback speed control
  - Audio balance adjustment
  - Save to favorites
  - Share option (template only, not audio)
  - Add to collection

## User Flows

### 1. First-Time User Flow
1. Welcome Screen → Personalization Questionnaire → Voice Preferences → Music Preferences
2. Home Screen with recommended templates
3. Quick tutorial overlay highlighting key features
4. Prompt to create first meditation or try a template

### 2. Meditation Creation Flow
1. Home Screen → Create Button
2. Step 1: Choose Purpose → Step 2: Select Voice → Step 3: Choose Sounds → Step 4: Customize Content
3. Preview Screen → Save or Edit
4. Option to play immediately or return to library

### 3. Quick Meditation Flow
1. Home Screen → Quick Create Template
2. Modified version of template shown with current selections
3. Option to customize further or start immediately
4. Playback Screen → Completion Screen with option to save modifications

### 4. Subscription Conversion Flow
1. Free user attempts to access premium feature
2. Elegant upgrade screen appears showing:
   - Feature comparison
   - Pricing options
   - Free trial offer
   - Testimonials
2. Payment flow with minimal steps
3. Success screen with suggested next actions

## Interactive Elements

### Custom Controls

#### Voice Selection Control
- Circular avatars with play button overlay
- Active state shows animated sound wave
- Tap to select, hold to hear extended sample
- Swipe between options

#### Sound Mixer
- Visual representation of layered sounds
- Drag to adjust relative volumes
- Pinch to adjust overall volume
- Tap to mute/unmute individual layers

#### Duration Slider
- Custom slider with haptic feedback
- Minute markers with subtle ticks
- Current selection prominently displayed
- Preset duration buttons (5, 10, 15, 30 min)

#### Guidance Level Selector
- Three-position segmented control
- Visual representation of guidance density
- Tooltip explanations on first use

### Animations and Transitions

#### Screen Transitions
- Smooth cross-dissolves between creation steps
- Subtle parallax effect on home screen cards
- Elegant slide-up for modal screens

#### Feedback Animations
- Gentle pulse when selections are made
- Subtle glow effect for active elements
- Progress indicators with calming animation

#### Playback Visualizations
- Subtle background animation during playback
- Breathing guide animation (optional)
- Sound wave visualization for voice and music

## Responsive Design

### Phone Layouts (Portrait)
- Single column layout
- Bottom navigation
- Scrolling content areas
- Modal dialogs for detailed options

### Phone Layouts (Landscape)
- Two-column layout where appropriate
- Collapsed bottom navigation
- Optimized player controls

### Tablet Layouts
- Multi-column layouts
- Sidebar navigation option
- Expanded creation interface with simultaneous steps
- Split-screen options for advanced users

## Accessibility Considerations

### Vision Accommodations
- Support for dynamic text sizing
- High contrast mode
- Screen reader compatibility
- Alternative text for all images

### Motor Accommodations
- Large touch targets (minimum 44×44 points)
- Reduced motion option
- Voice control support
- Adjustable timing for interactions

### Cognitive Accommodations
- Clear, consistent navigation
- Simplified mode option
- Step-by-step guidance
- Reduced text option with more icons

## Implementation Notes

These mockups should be implemented using Flutter with Material Design components as a foundation, but with significant customization to achieve the premium, unique aesthetic described. The design system should be built with a component-based approach to ensure consistency across the app.

Custom animations should be implemented with attention to performance, especially on lower-end devices. The design should gracefully degrade on older devices while maintaining core functionality and aesthetic appeal.

The UI should be implemented with accessibility as a primary consideration, not an afterthought, ensuring all users can enjoy the full meditation creation experience regardless of abilities or limitations.
