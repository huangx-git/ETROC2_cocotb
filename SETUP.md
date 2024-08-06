# Repository and Environment Setup

## Repository

Clone the current repository as a one time operation:

```bash
git clone --recursive ssh://git@gitlab.cern.ch:7999/gdigugli/etroc2-cocotb.git
```

**NOTE** The current repository includes the following submodules:

- The ETROC2 code base (`ETROC2_cocotb/ETROC2`)
- Some general notes on the ETROC2 manual (`ETROC2_cocotb/ETROC2_RefManualNotes`)

**NOTE** Use the `master` branch.

For the future, besides the usual git operations, remember to use `git pull --recurse-submodules` to update the submodules to the latest changes.

## Python Environment

We use a Python virtual environment for the _ETROC2 cocotb_ verification setup. More details are provided [here](https://docs.python.org/3.10/tutorial/venv.html).

**NOTE** If you are using the servers of the _ME Division_ cluster (e.g. `fasic-beast1.fnal.gov`), add the following line at the end of your `.bashrc` file:

```bash
source /opt/rh/rh-python38/enable
```

To setup the Python environment for the first time:

```bash
python -m venv $HOME/venvs/cocotb-env
source $HOME/venvs/cocotb-env/bin/activate
pip install cocotb pytest
```

When the Python environment is active, you will notice the prefix `(cocotb-env)` on the command line.

To add a new Python package:

```bash
pip install NEW_PACKAGE_NAME
```

To deactivate the environment:

```bash
deactivate
```

In any new console, remember to activate the environment:

```bash
source $HOME/venvs/cocotb-env/bin/activate
```

## CAD Tools

Besides the Python virtual environment that provides cocotb and other Python libraries, you need the following CAD tools:

- **Cadence _Xcelium_** (Logic Simulator), tested with _v23.09_
~~- **Cadence _vManager_** (Verification Manager), tested with _v24.03_~~

**NOTE** If you are using the servers of `sphy7asic01`, or `sphy7asic02`, the following script(s) will be loaded to setup the environment:

`start.sh` in cocotb directory

```bash
source start.sh
```

Please copy those scripts and adapt them to your needs.
