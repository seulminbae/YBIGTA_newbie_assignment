# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
## TODO

# 1. OS 확인
OS_NAME="$(uname -s)"
ARCH_NAME="$(uname -m)"

# 2. 이미 conda 있는지 검사
if command -v conda &> /dev/null; then
    echo "[INFO] 시스템에 이미 Conda가 설치되어 있음"
    eval "$(conda shell.bash hook)"
else
    echo "[INFO] Conda 미설치"
    
    if [[ "$OS_NAME" == "Darwin" ]]; then
        if [[ "$ARCH_NAME" == "arm64" ]]; then
            echo "[INFO] MacOS ARM65 Miniconda 다운로드"
            URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        else
            echo "[INFO] MacOS x86>64 Miniconda 다운로드"
            URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
        fi
        INSTALLER="miniconda_mac.sh"
        curl --retry 3 -sL "$URL" -o "$INSTALLER"
        bash "$INSTALLER" -b -u -p "$HOME/miniconda3"
        eval "$("$HOME/miniconda3/bin/conda" shell.bash hook)"
        rm -f "$INSTALLER"

    elif [[ "$OS_NAME" == "Linux" ]]; then
        if [[ "$ARCH_NAME" == "aarch64" || "$ARCH_NAME" == "arm64" ]]; then
            echo "[INFO] Linux ARM64 Miniconda 다운로드"
            URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
        else
            echo "[INFO] Linux x86_64 Miniconda 다운로드"
            URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
        fi
        
        INSTALLER="miniconda_linux.sh"
        curl --retry 3 -sL "$URL" -o "$INSTALLER"
        bash "$INSTALLER" -b -u -p "$HOME/miniconda3"
        eval "$("$HOME/miniconda3/bin/conda" shell.bash hook)"
        rm -f "$INSTALLER"

    elif [[ "$OS_NAME" == *"MINGW"* || "$OS_NAME" == *"CYGWIN"* ]]; then
        echo "[INFO] Window x86_64 Miniconda 다운로드"
        URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
        INSTALLER="miniconda_win.exe"
        curl --retry 3 -sL "$URL" -o "$INSTALLER"
        
        WIN_INSTALL_PATH="$(cygpath -w "$USERPROFILE/Miniconda3")"
        ./"$INSTALLER" //InstallationType=JustMe //RegisterPython=0 //S //D="$WIN_INSTALL_PATH"
        
        export PATH="$USERPROFILE/Miniconda3/Scripts:$USERPROFILE/Miniconda3/condabin:$PATH"
        eval "$(conda shell.bash hook)"
        rm -f "$INSTALLER"
    else
        echo "[ERROR] 운영체제 오류"
        exit 1
    fi
fi

# 3. 약관 동의
if command -v conda &> /dev/null; then
    echo "[INFO] Anaconda 기본 채널 이용약관 자동 동의"
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main &> /dev/null || true
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r &> /dev/null || true
fi

# Conda 환셩 생성 및 활성화
## TODO
conda create --name myenv python==3.11 -y
conda activate myenv

## 건드리지 마세요! ##
python_env=$(python -c "import sys; print(sys.prefix)")
if [[ "$python_env" == *"/envs/myenv"* ]]; then
    echo "[INFO] 가상환경 활성화: 성공"
else
    echo "[INFO] 가상환경 활성화: 실패"
    exit 1 
fi

# 필요한 패키지 설치
## TODO
pip install mypy

# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }

mkdir -p ../output

for file in *.py; do
    ## TODO
    prob_num="${file%.*}"
    prob_num="${prob_num#*_}"

    echo "[INFO] ${prob_num}번 문제"
    python "$file" <"../input/${prob_num}_input" >"../output/${prob_num}_output"

done

# mypy 테스트 실행 및 mypy_log.txt 저장
## TODO
mypy *.py > ../mypy_log.txt || true

# conda.yml 파일 생성
## TODO
cd ..
conda env export > conda.yml

# 가상환경 비활성화
## TODO
conda deactivate
echo "[INFO] 다 끝!"