start=95
end=105
step=1

for latt in $(seq $start $step $end); 
do

scale=$(awk "BEGIN {printf \"%.3f\", $latt/100}")
echo "Running for scaling ratio: $scale (latt=$latt)"

a1=$(awk "BEGIN {printf \"%.6f\", 4.001 * $scale}")
a2=$(awk "BEGIN {printf \"%.6f\", -2.0005 * $scale}")
a3=$(awk "BEGIN {printf \"%.6f\", 3.46529 * $scale}")

subdir="./ratio_$latt"
mkdir -p "$subdir"

cat > Fe3GeTe2_relax.fdf <<END

# FDF file for Fe3GeTe2 

# General System descriptors

SystemName Fe3GeTe2                  # Descriptive name of the system
SystemLabel Fe3GeTe2_relax           # Short name for naming files

NumberOfAtoms           6            # Number of atoms
NumberOfSpecies         3            # Number of species

%block Chemical_Species_Label
  1  26  Fe
  2  32  Ge
  3  52  Te
%endblock Chemical_Species_Label

PAO.BasisSize      DZP
PAO.EnergyShift    0.001 Ry

# Lattice, coordinates, k-sampling

AtomicCoordinatesFormat Ang #link: https://c2db.fysik.dtu.dk/material/1GeTe2Fe3-1
%block AtomicCoordinatesAndAtomicSpecies
       2.3659053000      1.7565516000     12.6863155300                 3
       2.3659053200      1.7565515200      7.5354052800                 3
       0.3378719300      2.9274093600     10.1108346300                 2
       0.3378767100      0.5856540700     11.3527281700                 1
       0.3378767400      0.5856540900      8.8689175800                 1
       2.3659139900      1.7565353000     10.1108330000                 1
%endblock AtomicCoordinatesAndAtomicSpecies


%block LatticeVectors
   $a1   0.000000   0.000000
   $a2   $a3   0.000000
   0.000000   0.000000  30.00000
%endblock LatticeVectors

%block kgrid_Monkhorst_Pack
  30   0   0
  0   30   0
  0   0   1
%endblock kgrid_Monkhorst_Pack


# DFT, Grid, SCF

XC.functional          GGA
XC.authors             PBE
SpinPolarized          .true.       # Spin polarized calculation

MeshCutoff              2000 Ry     # Equivalent planewave cutoff for the grid10
MaxSCFIterations        300         # Maximum number of SCF iterations per step
DM.MixingWeight         0.1         # New DM amount for next SCF cycle
DM.Tolerance            1.d-4       # Tolerance in maximum difference
                                    # between input and output DM
SCF.Mixer.History       4           # Number of SCF steps between pulay mixing

# Eigenvalue problem: order-N or diagonalization

SolutionMethod          diagon      # OrderN or Diagon
ElectronicTemperature   5 K        # Temp. for Fermi smearing

# Molecular dynamics and relaxations

MD.TypeOfRun            CG
MD.Steps                1000
MD.MaxCGDispl           0.05 Ang
MD.MaxForceTol          0.005 eV/Ang
MD.UseSaveXV            T
MD.UseSaveCG            T



# Output options

WriteCoorInitial        .true.
WriteCoorStep           .true.
WriteForces             .true.
WriteKpoints            .false.
WriteEigenvalues        .false.
WriteKbands             .false.
WriteBands              .false.
WriteMullikenPop        1            # Write Mulliken Population Analysis
WriteCoorXmol           .false.
WriteMDCoorXmol         .false.
WriteMDhistory          .false.
WriteCoorXmol           .false.

# Options for saving/reading information

DM.UseSaveDM             T           # Use DM Continuation files
MD.UseSaveXV            .false.      # Use stored positions and velocities
MD.UseSaveCG            .false.      # Use stored positions and velocities
SaveRho                  T           # Write valence pseudocharge at the mesh
SaveDeltaRho             T           # Write RHOscf-RHOatm at the mesh
SaveElectrostaticPotential .false.   # Write the total elect. pot. at the mesh
SaveTotalPotential      .false.      # Write the total pot. at the mesh
WriteSiestaDim          .false.      # Write minimum dim to siesta.h and stop
WriteDenchar             T           # Write information for DENCHAR
Diag.ParallelOverK       T

    
END

mv Fe3GeTe2_relax.fdf "$subdir/"
cp run_siesta.sh "$subdir/"
cp Ge.psf "$subdir/"
cp Te.psf "$subdir/"
cp Fe.psf "$subdir/"

cd "$subdir/"
sbatch run_siesta.sh
cd ..

done
