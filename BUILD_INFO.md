# PyInstaller Build Information

## Project Setup
- **Project Name**: Side Project CLI
- **Python Version**: >=3.12.9
- **Main Dependencies**: Typer, Rich
- **Entry Point**: `side_project.main:main`

## Build Configuration

### PyInstaller Spec File: `side-project.spec`
- **Entry Script**: `side_project/main.py`
- **Output Name**: `side-project`
- **Build Type**: Single file executable (--onefile)
- **Console Mode**: Yes
- **Hidden Imports**: typer, rich.*, click, shellingham

### Build Scripts
1. **`build.sh`** - macOS/Linux build script
2. **`build.bat`** - Windows build script
3. **`create_package.sh`** - Package creation script

## Build Process

### Step 1: Install Dependencies
```bash
pip install pyinstaller
```

### Step 2: Build Executable
```bash
# On macOS/Linux
./build.sh

# On Windows
build.bat

# Manual build
pyinstaller side-project.spec
```

### Step 3: Test Executable
```bash
./dist/side-project --help
./dist/side-project hello "Test"
```

### Step 4: Create Distribution Package
```bash
./create_package.sh
```

## Output Details

### Executable File
- **Location**: `dist/side-project` (macOS/Linux) or `dist/side-project.exe` (Windows)
- **Size**: ~36MB (includes Python runtime and all dependencies)
- **Architecture**: Native (ARM64 on Apple Silicon, x64 on Intel)

### Distribution Package
- **Format**: `.tar.gz` archive
- **Contents**: 
  - Executable file
  - README.txt with installation instructions
- **Location**: `dist/side-project-cli-YYYYMMDD.tar.gz`

## Platform-Specific Notes

### macOS
- Executable is code-signed automatically
- May show security warning on first run (Gatekeeper)
- Universal binary support depends on Python installation

### Windows
- May require Visual C++ Redistributable
- Windows Defender might scan the executable
- Use `.exe` extension

### Linux
- Requires same or compatible glibc version
- May need to install additional system libraries
- Consider creating AppImage for better compatibility

## Troubleshooting

### Common Issues
1. **Missing modules**: Add to `hiddenimports` in spec file
2. **Large file size**: Use `--exclude-module` for unused packages
3. **Slow startup**: Consider using `--noupx` flag
4. **Import errors**: Check `hookspath` and `runtime_hooks`

### Optimization Tips
1. Use virtual environment with minimal dependencies
2. Exclude unused packages: `--exclude-module matplotlib,numpy`
3. Use UPX compression: `upx=True` (already enabled)
4. Consider using `--onedir` instead of `--onefile` for faster startup

## Development Workflow

1. Develop and test with `pip install -e .`
2. Build executable with `./build.sh`
3. Test executable functionality
4. Create distribution package
5. Test on clean system without Python