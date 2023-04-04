# Gromacs yordamida molekular modellashtirish

## Kirish | GROMACS yordamida suvni modellashtirish / Introduction | Modeling of water using GROMACS

### 1. Gromacsni yuklab olamiz va default fayllarini o'zimiz ishlayotgan papkaga ko'chirib olamaiz

```bash
sudo apt install gromacs
locate spc216.gro
cp /usr/share/gromacs/top/spc216.gro ./
```

### 1.2. GPU kartasi bor kompyuterlar uchun:
1. Download Gromacs from: https://manual.gromacs.org/current/download.html

2. CUDA TOOLKIT:
    
    https://developer.nvidia.com/cuda-downloads

    Follow the steps and copy the commands

3. Gromacs Compilation Process

```bash
tar xfz gromacs-2020.2.tar.gz
cd gromacs-2020.2
mkdir build
cd build
cmake .. -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
make
make check
sudo make install

# Add this code to your .bashrc or .bashrc_profile file:
source /usr/local/gromacs/bin/GMXRC

# https://manual.gromacs.org/current/install-guide/index.html
```

### 2. `topology` tuzib olish uchun buyruq
```bash 
gmx pdb2gmx -f spc216.gro
default OPLS -> 16
default SPC -> 6
```
### 3. `box` o'lchamlarini oshirish orqali sistemadagi suv molekulalar sonini oshirish:
```bash
gmx solvate -cs conf.gro -o out_conf.gro -box 2.5 -p topol.top
```

### 4. Energy minimization of water (min.mdp -> boundary = xyz)
> min.mdp fayl kerak
```bash
gmx grompp -f min.mdp -c out_conf.gro -p topol.top -o min -maxwarn
gmx mdrun -deffnm min -v
```

### 5. position restrained MD
> pr.mdp fayli kerak
```bash
gmx grompp -v -f pr.mdp -c min.gro -p topol.top -o pr -maxwarn 2
gmx mdrun -v -deffnm pr   
```
 
### 6. NVT
```bash
gmx grompp -v -f nvt.mdp -c pr.gro -p topol.top -o nvt -maxwarn 2
gmx mdrun -v -deffnm nvt
```

### 7. NPT
```bash
gmx grompp  -f npt.mdp -c nvt.gro -p topol.top -o npt -maxwarn 2 
gmx mdrun -deffnm npt
```

### 8. Trayektoriyani hisoblash
```bash
gmx trjconv -s npt.tpr -f npt.trr -o frames.pdb -pbc mol
```

### 9. Analyse
```bash
gmx energy -f npt.edr -o temp.xvg
xmgrace temp.xvg
gmx energy -f npt.edr -o press.xvg
```
