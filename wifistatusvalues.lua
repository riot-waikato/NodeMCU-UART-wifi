--[[Tables containing human-readable translations of:
    - wifi.eventmon.reason (disconnect reasons)
    - wifi.sta.status()

    Can be used in error messages or in an interactive session instead of referring
    to documentation.
--]]

--wifi.sta.status()
function wifistatus_tostr(value)
    local wifistatus = {}
    wifistatus[1]="STA_IDLE"
    wifistatus[2]="STA_CONNECTING"
    wifistatus[3]="STA_APNOTFOUND"
    wifistatus[4]="STA_FAIL"
    wifistatus[5]="STA_GOTIP"

    return wifistatus[value]
end

--wifi disconnect reasons
function dcreason_tostr(value)
    local reason = {}
    reason[1] = "UNSPECIFIED"
    reason[2] = "AUTH_EXPIRE"
    reason[3] = "AUTH_LEAVE"
    reason[4] = "ASSOC_EXPIRE"
    reason[5] = "ASSOC_TOOMANY"
    reason[6] = "NOT_AUTHED"
    reason[7] = "NOT_ASSOCED"
    reason[8] = "ASSOC_LEAVE"
    reason[9] = "ASSOC_NOT_AUTHED"
    reason[10] = "DISASSOC_PWRCAP_BAD"
    reason[11] = "DISASSOC_SUPCHAN_BAD"
    reason[13] = "IE_INVALID"
    reason[14] = "MIC_FAILURE"
    reason[15] = "4WAY_HANDSHAKE_TIMEOUT"
    reason[16] = "GROUP_KEY_UPDATE_TIMEOUT"
    reason[17] = "IE_IN_4WAY_DIFFERS"
    reason[18] = "GROUP_CIPHER_INVALID"
    reason[19] = "PAIRWISE_CIPHER_INVALID"
    reason[20] = "AKMP_INVALID"
    reason[21] = "UNSUPP_RSN_IE_VERSION"
    reason[22] = "INVALID_RSN_IE_CAP"
    reason[23] = "802_1X_AUTH_FAILED"
    reason[24] = "CIPHER_SUITE_REJECTED"
    reason[200] = "BEACON_TIMEOUT"
    reason[201] = "NO_AP_FOUND"
    reason[202] = "AUTH_FAIL"
    reason[203] = "ASSOC_FAIL"
    reason[204] = "HANDSHAKE_TIMEOUT"

    return reason[value]
end
