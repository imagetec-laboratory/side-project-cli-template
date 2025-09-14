# -*- mode: python ; coding: utf-8 -*-

a = Analysis(
    ['side_project/main.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        'typer',
        'rich.console',
        'rich.table',
        'rich.markdown',
        'rich.syntax',
        'rich.text',
        'rich.panel',
        'rich.progress',
        'click',
        'shellingham',
        # Add our own modules
        'side_project.commands',
        'side_project.utils',
        'side_project.config',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='side-project',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
