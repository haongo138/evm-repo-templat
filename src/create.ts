import * as prompts from '@clack/prompts';

import { getProjectDir } from './utils/directory';

import { checkMinimumRequirements } from './tasks/checkMinimumRequirements';
import { getUserInput } from './tasks/getUserInput';
import { checkProjectDir } from './tasks/checkProjectDir';
import { setupEnvFiles } from './tasks/setupEnvFiles';
import { setupProject } from './tasks/setupProject';
import { outro } from './tasks/outro';

export const createProject = async () => {
  await checkMinimumRequirements();

  prompts.intro('Create your own dApp with @df/evm-apps!');

  const { project, envVars } = await getUserInput();
  
  const projectDir = getProjectDir(project.name);
  checkProjectDir(projectDir);
  
  await setupProject(projectDir, project);

  setupEnvFiles(projectDir, envVars);

  outro(project.name);

  process.exit(0);
};