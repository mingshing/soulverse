
# Use different lane to change the Summit build configuration is Debug / Release
# development --> Debug
# release --> Release

# Use different env to change the KPS server we used
# We have dev / staging / production server
# --env dev          --> dev server endpoint
# --env staging      --> staging server endpoint
# --env prod         --> production server endpoint


The following command would submit Summit Dev App, with Debug build configuration to iTunesConnect

fastlane development --env dev


