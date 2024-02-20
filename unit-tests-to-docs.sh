# Copies tests from unit-test-reports to docs

cd unit-test-reports

# Get pattern from shell command passed in
if 
  [[ $1 = "" || $2 = "" ]]
then
  echo "Pass directory pattern to check for and new directory name"
  exit 1
fi

export TEST_DIR_PATTERN=$1
export NEW_DIR_PATTERN=$2

unset -v latest
for directory in $1; do
  [[ $directory -nt $latest ]] && latest=$directory
done

if 
  [ -z "$latest" ]
then
  echo "Cannot find test directory matching $1"
else
  rm -rf ../docs/references/testreports/$NEW_DIR_PATTERN
  mkdir -p ../docs/references/testreports/$NEW_DIR_PATTERN
  cp -r ./$directory/* ../docs/references/testreports/$NEW_DIR_PATTERN

  echo "Copied files"
fi

exit 0