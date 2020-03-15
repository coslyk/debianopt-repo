#!/bin/bash

# Patch appdata and desktop file
sed -i 's|/usr/share/@@NAME@@/@@NAME@@|@@NAME@@|g
        s|@@NAME_SHORT@@|Code|g
        s|@@NAME_LONG@@|Code|g
        s|@@NAME@@|code|g
        s|@@ICON@@|code|g
        s|@@EXEC@@|/usr/bin/code|g
        s|@@LICENSE@@|MIT|g
        s|@@URLPROTOCOL@@|vscode|g
        s|inode/directory;||' resources/linux/code{.appdata.xml,.desktop,-url-handler.desktop}

# Patch completitions with correct names
sed -i 's|@@APPNAME@@|code|g' resources/completions/{bash/code,zsh/_code}

# Fix bin path
sed -i "s|return path.join(path.dirname(execPath), 'bin', \`\${product.applicationName}\`);|return '/usr/bin/code';|g
        s|return path.join(appRoot, 'scripts', 'code-cli.sh');|return '/usr/bin/code';|g" \
        src/vs/platform/environment/node/environmentService.ts