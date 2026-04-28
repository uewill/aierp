# Arco Design Mobile - Quick Reference

## 🎨 Colors

```dart
// Primary
Color(0xFF165DFF)  // primary
Color(0xFF4080FF)  // hover
Color(0xFF0E42D2)  // active
Color(0xFFE8F3FF)  // light

// Semantic
Color(0xFF00B42A)  // success
Color(0xFFFF7D00)  // warning
Color(0xFFF53F3F)  // danger

// Neutral
Color(0xFF1D2129)  // text primary
Color(0xFF4E5969)  // text secondary
Color(0xFF86909C)  // text tertiary
Color(0xFFC9CDD4)  // placeholder
Color(0xFFE5E6EB)  // border
Color(0xFFF7F8FA)  // background
Color(0xFFFFFFFF)  // white/surface
```

## 📏 Spacing (8px Grid)

```dart
4   // xs
8   // s
16  // m (standard)
24  // l
32  // xl
48  // xxl
```

## 🔤 Typography

```dart
30/Bold      // display1
24/Bold      // display2
20/Medium    // title1
16/Medium    // title2
16/Regular   // body1
14/Regular   // body2
12/Regular   // body3
11/Regular   // caption
```

## ⬜ Border Radius

```dart
2px   // tags
4px   // buttons, inputs, cards (standard)
8px   // dialogs, popups
9999  // circular (avatars)
```

## 🔘 Button Sizes

| Size | Height | Font |
|------|--------|------|
| Small | 28px | 12px |
| Medium | 32px | 14px |
| Large | 40px | 14px |

## 📱 Touch Targets

- Minimum: 44x44px
- Recommended: 48x48px

## 🎭 Animation Durations

```dart
150ms  // fast (hover)
200ms  // normal (buttons)
300ms  // slow (modals)
```

## 💡 Quick Component Patterns

### Button
```dart
ArcoButton(
  label: 'Submit',
  onPressed: handleSubmit,
  type: ArcoButtonType.primary,
  size: ArcoButtonSize.medium,
)
```

### Input
```dart
ArcoInput(
  label: 'Email',
  placeholder: 'Enter email',
  controller: controller,
  validator: validateEmail,
)
```

### Switch
```dart
ArcoSwitch(
  value: isOn,
  onChanged: (v) => setState(() => isOn = v),
)
```

### Checkbox
```dart
ArcoCheckbox(
  value: isChecked,
  label: 'Option',
  onChanged: (v) => setState(() => isChecked = v),
)
```

### Dialog
```dart
ArcoDialog.show(
  context: context,
  title: 'Confirm',
  content: 'Are you sure?',
  onConfirm: handleConfirm,
)
```

### Toast
```dart
ArcoToast.show(
  context: context,
  message: 'Success!',
  type: ToastType.success,
)
```

### Avatar
```dart
ArcoAvatar(
  imageUrl: url,
  size: 40,
  shape: AvatarShape.circle,
)
```

### Badge
```dart
ArcoBadge(
  count: 5,
  child: Icon(Icons.notifications),
)
```

### Tag
```dart
ArcoTag(
  label: 'New',
  type: TagType.primary,
)
```

### TabBar
```dart
ArcoTabBar(
  tabs: ['Tab 1', 'Tab 2'],
  currentIndex: index,
  onChanged: setIndex,
)
```

### NavBar
```dart
ArcoNavBar(
  title: 'Title',
  leftWidget: backIcon,
  rightWidget: menuIcon,
)
```

### Cell
```dart
ArcoCell(
  title: 'Settings',
  icon: Icons.settings,
  trailing: Icon(Icons.chevron_right),
  onTap: goToSettings,
)
```

### Slider
```dart
ArcoSlider(
  value: value,
  min: 0,
  max: 100,
  onChanged: setValue,
)
```

### Rate
```dart
ArcoRate(
  value: rating,
  count: 5,
  onChanged: setRating,
)
```

### Progress
```dart
ArcoProgress(
  value: 60,
  showLabel: true,
)
```

## ✅ Quality Checklist

Before shipping:
- [ ] Colors use design tokens
- [ ] Spacing on 8px grid
- [ ] All states implemented
- [ ] Touch targets ≥ 44px
- [ ] Contrast ratios OK
- [ ] Tests written
- [ ] No hardcoded values
- [ ] Responsive tested

## 🚀 Theme Setup

```dart
MaterialApp(
  theme: ArcoTheme.lightTheme,
  home: MyScreen(),
)
```

## 📦 Common Imports

```dart
import 'package:flutter/material.dart';
import '../arco_design/arco_design.dart';
```

---

**Remember:** Always use design tokens! Never hardcode colors or spacing.
