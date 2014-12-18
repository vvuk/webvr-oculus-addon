/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

Components.utils.import("resource://gre/modules/Services.jsm");

function startup(data, reason)
{

  var platformOS, platformABI;
  try {
    platformOS = Services.appinfo.OS;
    platformABI = Services.appinfo.XPCOMABI;
  } catch (e) {
    Services.console.logStringMessage("Oculus WebVR enabler, exception: " + e);
    // failed to get the ABI; can't construct a directory
    return;
  }

  var ovrDir, ovrFile;
  var fullPlatform = platformOS + "-" + platformABI;
  switch (fullPlatform) {
    case "WINNT-x86-msvc":
      ovrDir = "WINNT";
      ovrFile = "libovr32.dll";
      break;
    case "WINNT-x86_64-msvc":
      ovrDir = "WINNT";
      ovrFile = "libovr64.dll";
      break;
    case "Darwin-i386-gcc3":
    case "Darwin-x86_64-gcc3":
      ovrDir = "Darwin";
      ovrFile = "libovr.dylib";
      break;
    case "Linux-i386-gcc3":
      ovrDir = "Linux";
      ovrFile = "libovr.so";
      break;
    case "Linux-x86_64-gcc3":
      ovrDir = "Linux";
      ovrFile = "libovr64.so";
      break;
    default:
      Services.console.logStringMessage("Oculus WebVR enabler: missing libovr for platform: " + fullPlatform);
      return;
  }

  var file = data.installPath.clone()
  file.append(ovrDir);
  file.append(ovrFile);
  if (!file.exists()) {
    Services.console.logStringMessage("Oculus WebVR enabler: trying to use " + file.path + " but it doesn't exist?");
    return;
  }

  var vrBranch = Services.prefs.getDefaultBranch("dom.vr.");
  vrBranch.setCharPref("ovr_lib_path", file.path);
}

function shutdown(data, reason)
{
}

function install(data, reason)
{
}

function uninstall(data, reason)
{
}
