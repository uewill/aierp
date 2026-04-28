# Arco Design Mobile - Implementation Workflow

## Overview

Step-by-step guide to implementing Arco Design Mobile components in Flutter.

## Phase 1: Setup (5 min)

### 1. Create Project Structure

```bash
mkdir -p lib/arco_design/{theme,components/{basic,form,feedback,display,navigation}}
```

### 2. Add Theme

```dart
// lib/arco_design/theme/arco_theme.dart
import 'package:flutter/material.dart';

class ArcoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF165DFF),
      scaffoldBackgroundColor: Color(0xFFF7F8FA),
      // ... full theme config
    );
  }
}
```

### 3. Apply Theme

```dart
// lib/main.dart
MaterialApp(
  theme: ArcoTheme.lightTheme,
  home: HomePage(),
)
```

## Phase 2: Implement Core Components (30-60 min)

### Priority Order

1. **Button** - Most used component
2. **Input** - Form foundation
3. **Switch/Checkbox/Radio** - Basic form controls
4. **Dialog/Toast** - Feedback
5. **Avatar/Badge/Tag** - Data display
6. **TabBar/NavBar** - Navigation

### Implementation Template

For each component:

```dart
/// [Component Name] following Arco Design specs
class Arco[Component] extends [StatelessWidget/StatefulWidget] {
  // Properties
  final Type type;
  final Size size;
  final ValueChanged<T>? onChanged;
  
  const Arco[Component]({
    Key? key,
    required this.property,
    this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implementation using design tokens
    return Container(
      // Use ArcoColors, ArcoSpacing, etc.
    );
  }
}
```

### Key Principles

1. **Use Design Tokens**
   ```dart
   // ✅ Good
   color: ArcoColors.primary
   padding: EdgeInsets.all(ArcoSpacing.m)
   
   // ❌ Bad
   color: Color(0xFF165DFF)
   padding: EdgeInsets.all(16)
   ```

2. **Handle All States**
   - Default
   - Hover/Focus
   - Active/Pressed
   - Disabled
   - Loading
   - Error

3. **Follow 8px Grid**
   - All spacing: multiples of 4px
   - Preferred: multiples of 8px

4. **Accessibility First**
   - Touch targets ≥ 44x44px
   - Contrast ratio ≥ 4.5:1
   - Semantic labels

## Phase 3: Build Screens (60-120 min)

### Screen Template

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variables
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArcoNavBar(title: 'Title'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ArcoSpacing.m),
        child: Column(
          children: [
            // Use Arco components
          ],
        ),
      ),
    );
  }
}
```

### Common Patterns

#### Form Screen
```dart
Form(
  key: formKey,
  child: Column(
    children: [
      ArcoInput(label: 'Name', validator: validate),
      ArcoInput(label: 'Email', validator: validateEmail),
      ArcoButton(label: 'Submit', onPressed: submit),
    ],
  ),
)
```

#### List Screen
```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => Divider(height: 1),
  itemBuilder: (context, index) {
    return ArcoCell(
      title: items[index].title,
      onTap: () => handleTap(items[index]),
    );
  },
)
```

#### Settings Screen
```dart
Column(
  children: [
    ArcoCell(
      title: 'Notifications',
      trailing: ArcoSwitch(value: enabled, onChanged: toggle),
    ),
    ArcoCell(
      title: 'Language',
      trailing: Text('English'),
      onTap: selectLanguage,
    ),
  ],
)
```

## Phase 4: Testing (15-30 min)

### Widget Tests

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Component works', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ArcoComponent(property: value),
      ),
    );
    
    expect(find.byType(ArcoComponent), findsOneWidget);
  });
}
```

### Visual Testing

1. Run on multiple devices
2. Compare with Figma designs
3. Check all states
4. Test edge cases

### Accessibility Testing

1. Enable screen reader
2. Test keyboard navigation
3. Check color contrast
4. Verify touch targets

## Phase 5: Optimization (15 min)

### Performance

1. Use `const` constructors
2. Avoid unnecessary rebuilds
3. Implement list caching
4. Lazy load heavy components

```dart
// ✅ Good
const ArcoButton(label: 'Click')

// ❌ Bad
ArcoButton(label: 'Click')  // Rebuilds every time
```

### Code Quality

1. Add dartdoc comments
2. Extract reusable widgets
3. Follow DRY principle
4. Use meaningful names

## Common Pitfalls

### Problem 1: Colors Don't Match

**Solution:** Double-check hex values and opacity

### Problem 2: Spacing Looks Wrong

**Solution:** Use Figma inspect mode, follow 8px grid

### Problem 3: Typography Off

**Solution:** Check font family, weight, line height ratio

### Problem 4: States Missing

**Solution:** Implement all 6 states for interactive components

### Problem 5: Performance Issues

**Solution:** Profile with DevTools, use const widgets, optimize lists

## Tips for Efficiency

### 1. Batch Similar Components

Implement all buttons first, then all inputs, etc.

### 2. Use Snippets

Create IDE snippets for common patterns:

```json
{
  "Arco Button": {
    "prefix": "arcobtn",
    "body": [
      "ArcoButton(",
      "  label: '${1:Label}',",
      "  onPressed: ${2:() {}},",
      ")"
    ]
  }
}
```

### 3. Component Library

Build reusable library:

```
lib/arco_design/
├── components/
│   ├── basic/
│   ├── form/
│   ├── feedback/
│   ├── display/
│   └── navigation/
└── theme/
```

### 4. Documentation

Document as you go:
- Add comments
- Create examples
- Update changelog

## Quality Checklist

Before considering complete:

### Visual
- [ ] Colors match Figma
- [ ] Spacing on 8px grid
- [ ] Typography correct
- [ ] Border radius accurate
- [ ] Shadows match

### Functional
- [ ] All states work
- [ ] Validation works
- [ ] Loading states show
- [ ] Error handling good
- [ ] Navigation flows

### Responsive
- [ ] Works on small screens
- [ ] Works on large screens
- [ ] Text doesn't overflow
- [ ] Touch targets OK

### Accessibility
- [ ] Contrast ratios pass
- [ ] Screen reader works
- [ ] Keyboard nav works
- [ ] Focus indicators visible

### Performance
- [ ] No jank
- [ ] Lists cached
- [ ] Images optimized
- [ ] Rebuilds minimized

### Code Quality
- [ ] Components reusable
- [ ] Follows best practices
- [ ] Error handling complete
- [ ] Comments added
- [ ] Tests written

## Next Steps

After implementation:

1. **Refactor** - Extract reusable components
2. **Optimize** - Profile and fix bottlenecks
3. **Test** - Write comprehensive tests
4. **Document** - Update README with examples
5. **Share** - Contribute to team library

## Resources

- [Arco Design Official Docs](https://arco.design/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Performance Guide](https://docs.flutter.dev/perf)
