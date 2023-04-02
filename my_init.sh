#!/usr/bin/bash

#topology tuzib olish uchun komanda
gmx pdb2gmx -f spc216.gro 

#box o'lchamlarini oshirish orqali sistemadagi suv molekulalar sonini oshirish
gmx solvate -cs conf.gro -o conf1.gro -box 2.5 2.5 2.5  -p topol.top

# Energy minimization of water (min.mdp -> boundary = xyz)
gmx grompp -v -f min.mdp -c conf1.gro -p topol.top -o min  -maxwarn 2
gmx mdrun -v -deffnm min

# position restrained MD
gmx grompp -v -f pr.mdp -c min.gro -p topol.top -o pr  -maxwarn 2
gmx mdrun -v -deffnm pr   
 
#  NVT
gmx grompp -v -f nvt.mdp -c pr.gro -p topol.top -o nvt -maxwarn 2
gmx mdrun -v -deffnm nvt

# NPT
gmx grompp  -f npt.mdp -c nvt.gro -p topol.top -o npt -maxwarn 2 
gmx mdrun -deffnm npt


# Trayektoriya
gmx trjconv -f prod.trr -s prod.tpr -o frames.pdb -pbc mol -center

