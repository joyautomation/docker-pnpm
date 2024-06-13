// get-pnpm-versions.js

const { exec } = require('child_process');
const semver = require('semver');

// Function to get all versions of pnpm from npm registry
const getVersions = () => {
  return new Promise((resolve, reject) => {
    exec('npm view pnpm versions --json', (error, stdout) => {
      if (error) {
        return reject(error);
      }
      resolve(JSON.parse(stdout));
    });
  });
};

// Function to filter versions
const filterVersions = (versions) => {
  const sortedVersions = versions.sort(semver.compare).reverse();
  const uniqueMajorVersions = {};
  const latestThreeMajors = [];

  sortedVersions.forEach((version) => {
    const major = semver.major(version);
    if (!uniqueMajorVersions[major]) {
      uniqueMajorVersions[major] = version;
    }
  });

  const majorKeys = Object.keys(uniqueMajorVersions).sort((a, b) => b - a);
  for (let i = 0; i < 3 && i < majorKeys.length; i++) {
    latestThreeMajors.push(uniqueMajorVersions[majorKeys[i]]);
  }

  return latestThreeMajors;
};

// Main function to get and filter versions
const main = async () => {
  try {
    const versions = await getVersions();
    const filteredVersions = filterVersions(versions);
    console.log(filteredVersions);
  } catch (error) {
    console.error('Error fetching versions:', error);
  }
};

main();
