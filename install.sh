if [ $# -ne 2 ]
then
    echo "Usage: ./install.sh <project-name> <remote|local>"
    exit 1
fi

export PROJECT=$1
export TARGET=$2
export ROOT_DIR=`cwd`
export BASE_ENV=$ROOT_DIR/base.env

PROJECT=`echo "$PROJECT" | sed -e 's/\(.*\)/\L\1/'`
echo "Running installation for $PROJECT"

source $BASE_ENV
sh $PROJECT_INSTALL/install.sh
exit 0
