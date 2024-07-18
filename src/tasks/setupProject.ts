import { exec } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as prompts from '@clack/prompts';
import * as color from 'picocolors';
import {
  getAppDir,
  updatePackageJson,
  removeDownloadedApps,
  APPS_ENGINE_DIR,
  renameDownloadedFile,
} from '../utils/apps';
import { chains } from './constant';

function generateNavbarExperiencesList(projectDir: string, experiences) {
  const filePath = path.join(
    projectDir,
    '/web/src/components/layout/header/Experiences.tsx'
  );
  const content = `
import { ListItem } from './ListItem';

export function Experiences() {
  return (
    <>
${experiences
  .map(
    ({ value, label }) => `      <ListItem href="/${value}">${label}</ListItem>`
  )
  .join('\n')}
    </>
  );
}
`;
  fs.writeFileSync(filePath, content);
}

async function execAsync(command: string, options = {}) {
  return new Promise((resolve, reject) => {
    exec(command, options, (error, stdout) => {
      if (error) {
        reject(error);
      }
      resolve(stdout);
    });
  });
}

export async function setupProject(projectDir: string, project) {
  try {
    const spinner = prompts.spinner();

    spinner.start('Downloading coinbase/build-onchain-apps');

    removeDownloadedApps(APPS_ENGINE_DIR);

    await execAsync(
      'git clone https://github.com/coinbase/build-onchain-apps temp-df-evm-repo'
    );

    fs.cpSync(getAppDir(), projectDir, {
      recursive: true,
    });

    removeDownloadedApps(APPS_ENGINE_DIR);

    await execAsync('git init', { cwd: projectDir, stdio: 'ignore' });

    removeDownloadedApps(projectDir + '/contracts/lib/openzeppelin-contracts');
    removeDownloadedApps(projectDir + '/contracts/lib/forge-std');
    removeDownloadedApps(projectDir + '/contracts/lib/solady');

    spinner.message(
      'git submodule add https://github.com/openzeppelin/openzeppelin-contracts'
    );
    await execAsync(
      'git submodule add https://github.com/openzeppelin/openzeppelin-contracts contracts/lib/openzeppelin-contracts',
      {
        cwd: projectDir,
      }
    );

    spinner.message(
      'git submodule add https://github.com/foundry-rs/forge-std'
    );
    await execAsync(
      'git submodule add https://github.com/foundry-rs/forge-std contracts/lib/forge-std',
      {
        cwd: projectDir,
      }
    );

    spinner.message('git submodule add https://github.com/chiru-labs/ERC721A');
    await execAsync(
      'git submodule add https://github.com/chiru-labs/ERC721A contracts/lib/ERC721A',
      {
        cwd: projectDir,
      }
    );

    spinner.message('git submodule add https://github.com/vectorized/solady');
    await execAsync(
      'git submodule add https://github.com/vectorized/solady contracts/lib/solady',
      {
        cwd: projectDir,
      }
    );

    spinner.message('git submodule add https://github.com/dmfxyz/murky');
    await execAsync(
      'git submodule add https://github.com/dmfxyz/murky contracts/lib/murky',
      {
        cwd: projectDir,
      }
    );

    const isWebPackageJsonUpdated = updatePackageJson(
      projectDir + '/web',
      project.name
    );

    if (!isWebPackageJsonUpdated) {
      prompts.log.error(color.red('Error updating project package.json'));
      process.exit(1);
    }

    // Prepare simple homepage
    removeDownloadedApps(projectDir + '/web/app/home');
    renameDownloadedFile(
      projectDir + '/web/app/simple',
      projectDir + '/web/app/home'
    );

    await execAsync('git add .', { cwd: projectDir, stdio: 'ignore' });
    await execAsync('git commit -m "initalized with @df/evm-apps"', {
      cwd: projectDir,
      stdio: 'ignore',
    });

    spinner.stop(`New app ${project.name} created successfully! 🚀`);
  } catch (e) {
    console.error(e);
    prompts.log.error(color.red('Error initializing Git and Foundry'));
    process.exit(1);
  }
}