
# flatten the reclass structure

1. copy part of the existing model structure to local directory (aka kubernetes and infra directory)
2. strip system/service/cluster preffix

    ./classes-strip.sh top

3. fetch classes from shared place (https://github.com/epcim/classes-salt-formulas)

    ./classes-fetch.sh ../classes-salt-formulas/merged

