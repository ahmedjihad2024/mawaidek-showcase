# Flutter Cleanup Commands - All-in-One MD

## 🛠️ Install Tools (Run Once)

```bash
dart pub global activate dart_unused_files unused_assets_removal unused_import_remover
```

## 🧹 Full Cleanup Workflow

### 1. **Unused Dart Files**

```bash
dart_unused_files scan
```

**👀 Review list, delete manually**

### 2. **Unused Assets/Images**

```bash
unused_assets_removal --dry-run  # SCAN FIRST
unused_assets_removal --delete    # DELETE (CAREFUL!)
```

### 3. **Unused Imports** (2 Options)

**Option A: Built-in (Recommended)**

```bash
dart fix --apply --code=unused_import
```

**Option B: Package**

```bash
dart pub run unused_import_remover
```

## 🎯 Complete Script

```bash
flutter clean && flutter pub get && \
dart fix --apply --code=unused_import && \
flutter format . && \
flutter analyze && \
dart_unused_files scan && \
dart run unused_assets_removal --dry-run
```

## ✅ Safety Order

1. `git commit -m "Before cleanup"`
2. Run preview commands (`--dry-run`, `scan`)
3. Full cleanup
4. `flutter run` (test)
5. `git commit -m "Cleaned up"`

**Copy → Save as `cleanup_commands.md` → Done!** ✨[web:8][web:25]