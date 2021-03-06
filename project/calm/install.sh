#Author: Shantanu Shrivastava

# This script essentially installs the dev environment

echo "Sourcing project environment configuration"
source $PROJECT_ENV

runCommand() {
    cmd=$1
    echo "Running command $cmd"
    output=`$cmd`
    if [ $? -ne 0 ]
    then
        echo "Failed to execute $cmd command with error $output"
        exit 1
    fi
}

user=`whoami`
echo "Running for user: $user"

#TODO: Read from file
commandList=("yum -y install vim" \
"yum -y install zsh" \
"curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o ohmyzsh.sh" \
"sh ohmyzsh.sh" \
"rm ohmyzsh.sh" \
"pip install pycscope" \
"yum -y install cscope")

for work in "${commandList[@]}"; do
    runCommand "$work"
done

if [ "$CSCOPE_DIR" == "" ]
then
    echo "ERROR: cscope dir is not defined"
    exit 1
fi

# Create Cscope placeholder

mkdir -p $CSCOPE_TARGET_DIR 

echo "Copying cscope files"
cp -r $CSCOPE_DIR/* $CSCOPE_TARGET_DIR/

echo "cscope files have been installed, go to $CSCOPE_TARGET_DIR to generate tags"

echo "Installing vimrc config"
cp $VIMRC_DIR/vimrc $VIMRC_TARGET_DIR/.vimrc
cp -r $VIMRC_DIR/myvimrc $VIMRC_TARGET_DIR/.myvimrc 

if [ $TARGET = $LOCAL_VM ]
then
    echo "Target is $LOCAL_VM, hence setup bashrc config also"
    cp $BASH_DIR/profile $BASH_TARGET_DIR/.profile
    cp $BASH_DIR/bash_profile $BASH_TARGET_DIR/.bash_profile
fi

echo "Setting up cscope path in vimrc"
cat $VIMRC_DIR/myvimrc/genericvimrc | sed -e "s|<CSCOPE_HOME>|$CSCOPE_TARGET_DIR/|g" > $VIMRC_TARGET_DIR/.myvimrc/genericvimrc

echo "Excelsior!!!!!"
echo "Setup Done, Code, Sleep, Repeat!"
