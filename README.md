# Data and code to generate figures for the paper Jones et al., Stability of the Antarctic Ice Sheet during the pre-Industrial Holocene

///// Figures ///// 

Contains the Matlab code to produce Figures 1, 2, 3, 4 and 6.
#
///// AntarcticEmpiricalData /////

Contains the empirical data recording Holocene ice volume change used in Figures 2 and 3:

GroundingLine.mat - Holocene (and pre-Holocene) grounding line retreat ages, and the locations of evidence of grounding line readvance.

ThicknessChange_Cosmogenic.mat - Holocene cosmogenic nuclide exposure age data from nunataks, and the associated sample elevations at each site, extracted from ICE-D Antarctica (http://antarctica.ice-d.org/).

ThicknessChange_IceCore.mat - Holocene ice core snow accumulation rates, and model-derived changes in ice surface elevation at three sites.
#
///// AntarcticGlobalSeaLevel ///// 

Contains the sea level data used in Figures 6 and discussed in the paper:

GMSL.mat - Holocene changes in global mean sea level sourced from Antarctica, derived from the 11 ice sheet models (AntarcticIceSheetModels; Figure 4).

RelativeSeaLevel.mat - Holocene changes in relative sea level sourced from Antarctica, estimated from the ice sheet models (AntarcticIceSheetModels), and divided into two periods (rapid ice loss and ice mass gain).
#
///// AntarcticIceSheetModels /////

Contains ice sheet model output used in Figure 4:

A20 = Albrecht et al. (2020);  B14 = Briggs et al. (2014);  G14 = Golledge et al. (2014);  G20anu = Gomez et al. (2020), anu model;  G20i5g = Gomez et al. (2020), ICE-5G model;  K18ref = Kingslake et al. (2018), reference model;  P17ELRA = Pollard et al. (2017), ELRA model;  P17st = Pollard et al. (2017), standard model;  P18 = Pollard et al. (2018);  T18 = Tigchelaar et al. (2018);  W12 = Whitehouse et al. (2012).
#
///// AntarcticTopographyGL ///// 

Contains Antarctic spatial data used in Figures 2 and 3:

Ant_basins.mat - Ice sheet drainage basins, which are present-day basins extended to the continental shelf edge.

BedMachine_Antarctica_5km.mat - Present-day ice surface elevation and bed topography from BedMachine, resampled to 5 km horizontal resolution.

BedMachine_Antarctica_GL-coast.mat - Present-day grounding line position and coast (ice shelf front) from Bedmachine.
#
///// RatesGlobalMeanSeaLevel ///// 

Contains sea level change data used in Figure 1:

Future_E21.mat - Future projections (RCP2.6, RCP8.5) to 2100 CE from Edwards et al. (2021).

Historical_F20.mat - Historical observations (since 1900 CE) from Frederiske et al. (2020).

Holocene_L14.mat - Holocene composite from Lambeck et al. (2014).
#
///// Functions /////

Contains Matlab functions used to process and plot data for the figures.

