import os
import subprocess
from pathlib import Path
from monty.serialization import loadfn
import numpy as np

TEST_FILES_PATH = Path(__file__).parents[2] / "examples"


def test_espresso_hdf5():

    os.chdir(TEST_FILES_PATH / "espresso_hdf5")

    command = [
        "irrep",
        "-code=espresso",
        "-prefix=di",
    ]
    output = subprocess.run(command, capture_output=True, text=True)
    return_code = output.returncode
    assert return_code == 0, output.stderr

    # Load generated and reference output data
    data_ref = loadfn("ref_output.json")
    data_run = loadfn("irrep-output.json")

    # Check SpaceGroup
    sg_ref = data_ref['spacegroup']
    sg_run = data_run['spacegroup']
    assert sg_ref['name'] == sg_run['name']
    assert sg_ref['number'] == sg_run['number']
    assert sg_ref['spinor'] == sg_run['spinor']
    assert sg_ref['num symmetries'] == sg_run['num symmetries']
    assert sg_ref['cells match'] == sg_run['cells match']
    spinor = sg_ref['spinor']  # used later

    # Todo: implement safe check of symmetries

    # Check general properties of the band structure
    bs_ref = data_ref['characters and irreps'][0]['subspace']
    bs_run = data_run['characters and irreps'][0]['subspace']
    assert bs_ref['indirect gap (eV)'] == bs_run['indirect gap (eV)']
    assert bs_ref['Minimal direct gap (eV)'] == bs_run['Minimal direct gap (eV)']
    if spinor:
        assert bs_ref['Z4'] == bs_run['Z4']
        assert bs_ref['number of inversion-odd Kramers pairs'] == bs_run['number of inversion-odd Kramers pairs']
    else:
        assert bs_ref['number of inversion-odd states'] == bs_run['number of inversion-odd states']

    # Check properties at each k-point
    kp_ref = bs_ref['k points'][0]
    kp_run = bs_run['k points'][0]
    assert np.allclose(kp_ref['symmetries'], kp_run['symmetries'])
    assert np.allclose(kp_ref['energies_mean'], kp_run['energies_mean'], rtol=0., atol=1e-4)
    assert np.allclose(kp_ref['characters'], kp_run['characters'], rtol=0., atol=1e-4)
    assert kp_ref['characters refUC is the same'] == kp_run['characters refUC is the same']
    assert np.allclose(kp_ref['dimensions'], kp_run['dimensions'], rtol=0., atol=1e-4)

    # Remove output files created during run
    for test_output_file in (
            "irreptable-template",
            "trace.txt",
            "irrep-output.json"
    ):
        os.remove(test_output_file)
