*** Settings ***
Library           OperatingSystem

*** Variables ***
${HIDE.SH}        ${CURDIR}/../hide.sh
${REF_FILE}       ${CURDIR}/output-ref.xml
${TARGET_FILE}    ${CURDIR}/output.xml
${MASK}           **HIDDEN**

*** Test Cases ***
Display version: [-v] option
    [Setup]    Init mask file
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -v
    Then Should Be Equal As Integers    ${rc}    0
    And Should Contain    ${output}    hide.sh, version
    And Should Contain    ${output}    Copyright (C)
    And Should Contain    ${output}    License GPLv3+

Mask a value: [-m] option
    [Setup]    Init mask file
    Pattern matches n times    P4ssw0rd    4
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m P4ssw0rd ${TARGET_FILE}
    Should Be Equal As Integers    ${rc}    0
    Pattern matches n times    P4ssw0rd    0
    Pattern matches n times    ${MASK}    4
    And Should Contain    ${output}    Hidden variables [0]: 4 matches

Mask a value: [-m] option - value does not exist
    [Setup]    Init mask file
    Pattern matches n times    P4ssw0rdX    0
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m P4ssw0rdX ${TARGET_FILE}
    Should Be Equal As Integers    ${rc}    0
    Pattern matches n times    P4ssw0rdX    0
    Pattern matches n times    ${MASK}    0
    And Should Contain    ${output}    Hidden variables [0]: 0 matches

Mask a value: [-m] option - run twice with same value
    [Setup]    Init mask file
    Pattern matches n times    P4ssw0rd    4
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m P4ssw0rd ${TARGET_FILE}
    Should Be Equal As Integers    ${rc}    0
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m P4ssw0rd ${TARGET_FILE}
    Pattern matches n times    P4ssw0rd    0
    Pattern matches n times    ${MASK}    4
    And Should Contain    ${output}    Hidden variables [0]: 0 matches

Mask a value: [-m] option - run twice with different values
    [Setup]    Init mask file
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m fred ${TARGET_FILE}
    Should Be Equal As Integers    ${rc}    0
    Pattern matches n times    P4ssw0rd    4
    ${rc}    ${output} =    When Run and Return RC and Output    ${HIDE.SH} -m P4ssw0rd ${TARGET_FILE}
    Pattern matches n times    P4ssw0rd    0
    Pattern matches n times    ${MASK}    6
    And Should Contain    ${output}    Hidden variables [0]: 4 matches

Mask a value: [-m] option - Error file not found
    [Setup]    Init mask file
    ${rc}    ${output} =    Run And Return Rc And Output    ${HIDE.SH} -m P4ssw0rd wrong_file_name.xml
    Should Be Equal As Integers    ${rc}    1
    And Should Contain    ${output}    File "wrong_file_name.xml" does not exist, aborting.

*** Keywords ***
Pattern matches n times
    [Arguments]    ${pattern}    ${n}
    ${lines} =    Grep File    ${TARGET_FILE}    ${pattern}
    ${count} =    Get Count    ${lines}    ${pattern}
    Should Be Equal As Integers    ${n}    ${count}

Init mask file
    Copy File    ${REF_FILE}    ${TARGET_FILE}
