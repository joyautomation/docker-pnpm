# get-pnpm-versions.sh

# Fetch all versions of pnpm
versions=$(npm view pnpm versions --json)

# Use jq to parse JSON and semver to sort and filter versions
echo "$versions" | jq -r '.[]' | sort -rV | semver -r "<=7" | sort -V | awk '{
  # Get major version
  major=substr($0, 1, index($0, ".") - 1);
  # Keep track of the last version of each major version
  if (major != prev_major) {
    if (prev_major != "") {
      print last_version;
    }
    prev_major=major;
  }
  last_version=$0;
} END {print last_version}'
