echo "15" | ../../build/bin/gmx pdb2gmx -f 6LVN.pdb -o 6LVN_processed.gro -water spce
../../build/bin/gmx editconf -f 6LVN_processed.gro -o 6LVN_newbox.gro -c -d 1.0 -bt cubic
../../build/bin/gmx solvate -cp 6LVN_newbox.gro -cs spc216.gro -o 6LVN_solv.gro -p topol.top
../../build/bin/gmx grompp -f ions.mdp -c 6LVN_solv.gro -p topol.top -o ions.tpr
echo "13" | ../../build/bin/gmx genion -s ions.tpr -o 6LVN_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
../../build/bin/gmx grompp -f ions.mdp -c 6LVN_solv_ions.gro -p topol.top -o em.tpr

for i in seq 9; do

	../../build/bin/gmx mdrun -v -deffnm em >> debug.out
done
