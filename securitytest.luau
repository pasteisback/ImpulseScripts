print("\n")

warn("Made by no.luv(xor)")
warn("✅ - Protected, ⛔ - Unprotected, ⏺️ - Untested")

local function blockFunction(str)
    getgenv().BLOCKED_FUNCTION = Instance.new("DataStoreIncrementOptions")
    BLOCKED_FUNCTION:SetMetadata({ func = str })
end

local protected, vulnerable, untested = 0, 0, 0

local function testServiceFunction(serviceName, functionName, call)
    task.spawn(function()
        local s, e = pcall(call)
        if e == "Argument 1 missing or nil" or tostring(e):find("missing") then
            vulnerable += 1
            warn("  ⛔ " .. functionName)
        elseif s == true or tostring(e):find("attempt to index nil") == nil then
            protected += 1
            warn("  ✅ " .. functionName)
            blockFunction("game:GetService(\"" .. serviceName .. "\"):" .. functionName .. "()")
        else
            untested += 1
            warn("  ⏺️ " .. functionName .. " | Reason: " .. tostring(e))
        end
    end)
    task.wait(0.15)
end

local servicesToTest = {
    { service = "HttpRbxApiService", funcs = { "PostAsync", "PostAsyncFullUrl", "GetAsync", "GetAsyncFullUrl", "RequestAsync" } },
    { service = "ScriptContext", funcs = { "AddCoreScriptLocal" } },
    { service = "BrowserService", funcs = { "EmitHybridEvent", "ExecuteJavaScript", "OpenBrowserWindow", "OpenNativeOverlay", "ReturnToJavaScript", "SendCommand" } },
    { service = "MarketplaceService", funcs = { "GetRobuxBalance", "PerformPurchase", "PerformPurchaseV2", "PromptBundlePurchase", "PromptGamePassPurchase", "PromptProductPurchase", "PromptPurchase", "PromptRobloxPurchase", "PromptThirdPartyPurchase" } },
    { service = "HttpService", funcs = { "RequestInternal" } },
    { service = "GuiService", funcs = { "OpenBrowserWindow", "OpenNativeOverlay" } },
    { service = "OpenCloudService", funcs = { "HttpRequestAsync" } },
    { service = "CoreGui", funcs = { "TakeScreenshot", "ToggleRecording", "OpenVideosFolder" } },
    { service = "MessageBusService", funcs = { "Call", "GetLast", "GetMessageId", "GetProtocolMethodRequestMessageId", "GetProtocolMethodResponseMessageId", "MakeRequest", "Publish", "PublishProtocolMethodRequest", "PublishProtocolMethodResponse", "Subscribe", "SubscribeToProtocolMethodRequest", "SubscribeToProtocolMethodResponse" } },
    { service = "Players", funcs = { "ReportAbuse", "ReportAbuseV3" } },
    { service = "DataModel", funcs = { "Load", "OpenScreenshotsFolder" } },
    { service = "OmniRecommendationsService", funcs = { "MakeRequest" } },
    { service = "AvatarEditorService", funcs = {
    "NoPromptCreateOutfit", "NoPromptDeleteOutfit", "NoPromptRenameOutfit", "NoPromptSaveAvatar",
    "NoPromptSaveAvatarThumbnailCustomization", "NoPromptSetFavorite", "NoPromptUpdateOutfit",
    "PerformCreateOutfitWithDescription", "PerformRenameOutfit", "PerformSaveAvatarWithDescription",
    "PerformSetFavorite", "PerformUpdateOutfit", "PromptCreateOutfit", "PromptDeleteOutfit",
    "PromptRenameOutfit", "PromptSaveAvatar", "PromptSetFavorite", "PromptUpdateOutfit"
    } },
    { service = "CoreScriptService", funcs = { "SaveScriptProfilingData" } },
    { service = "PremiumService", funcs = {
        "GetUserSubscriptionDetailsInternalAsync", "GetUserSubscriptionStatusAsync"
    } },
    { service = "PurchaseService", funcs = {
        "PerformBulkPurchase", "PerformCancelSubscription", "PerformSubscriptionPurchase",
        "PerformSubscriptionPurchaseV2", "PrepareCollectiblesPurchase"
    } },
    { service = "PromptService", funcs = {
        "PromptBulkPurchase", "PromptCancelSubscription", "PromptCollectiblesPurchase",
        "PromptNativePurchaseWithLocalPlayer", "PromptPremiumPurchase", "PromptSubscriptionPurchase"
    } },
    { service = "ScreenshotService", funcs = {
        "CaptureScreenshot", "CreatePostAsync", "DeleteCapture", "DeleteCapturesAsync",
        "GetCaptureFilePathAsync", "SaveCaptureToExternalStorage", "SaveCapturesToExternalStorageAsync",
        "GetCaptureUploadDataAsync", "RetrieveCaptures", "SaveScreenshotCapture"
    } },
    { service = "IntegrityService", funcs = {
        "GetDeviceIntegrityToken", "GetDeviceIntegrityTokenYield"
    } },
    { service = "WebViewService", funcs = { "OpenWeChatAuthWindow", "OpenUrl" } },
    { service = "RunService", funcs = { "Run" } },
    { service = "LimitedService", funcs = { "RequestLimitedAsync" } }
}

for _, entry in ipairs(servicesToTest) do
    for _, func in ipairs(entry.funcs) do
        testServiceFunction(entry.service, func, function()
            return function()
                game:GetService(entry.service)[func](game:GetService(entry.service))
            end
        end)
    end
end

task.wait(#servicesToTest * 1.5)

local total = protected + vulnerable + untested
local rating = math.floor((protected / total) * 100)
print("\n")
warn("Summary")
warn("✅ Rating: " .. rating .. "% (" .. protected .. " out of " .. total .. ")")
warn("⛔ " .. vulnerable .. " unprotected functions")
warn("⏺️ " .. untested .. " untested functions")
