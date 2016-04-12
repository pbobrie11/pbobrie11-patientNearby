/// Controls broadcasting and scanning.  These values can be ORed together.
typedef NS_OPTIONS(NSInteger, GNSDiscoveryMode) {
  /// To discover which devices are nearby, broadcast a pairing code for others to scan. This is
  /// useful for scenarios where the pairing device is guaranteed only to scan.
  kGNSDiscoveryModeBroadcast = 1 << 0,

  /// To discover which devices are nearby, scan for other devices' pairing codes. This is useful
  /// for scenarios where the pairing device is guaranteed only to broadcast.
  kGNSDiscoveryModeScan = 1 << 1,

  /// To discover which devices are nearby, broadcast a pairing code and scan for other
  /// devices' pairing codes.
  kGNSDiscoveryModeDefault = kGNSDiscoveryModeBroadcast | kGNSDiscoveryModeScan,
};

/// Controls the mediums used for discovering nearby devices.  These values can be ORed together.
typedef NS_OPTIONS(NSInteger, GNSDiscoveryMediums) {
  /// Use near-ultrasonic audio to discover nearby devices.
  kGNSDiscoveryMediumsAudio = 1 << 0,

  /// Use Bluetooth Low Energy to discover nearby devices.
  kGNSDiscoveryMediumsBLE = 1 << 1,

  /// Let Nearby decide which mediums are used to discover nearby devices.
  kGNSDiscoveryMediumsDefault = kGNSDiscoveryMediumsAudio | kGNSDiscoveryMediumsBLE,
};

/// Optional params for a strategy. See properties with the same names in GNSStrategy.
@interface GNSStrategyParams : NSObject
@property(nonatomic) GNSDiscoveryMode discoveryMode;
@property(nonatomic) GNSDiscoveryMediums discoveryMediums;
@property(nonatomic) BOOL includeBLEBeacons __attribute__((deprecated));
@end

/// The strategy to use to detect nearby devices.
@interface GNSStrategy : NSObject

/// For nearby device discovery, one device must broadcast a pairing code and the other device must
/// scan for pairing codes.  Because there is no way to negotiate beforehand, the default is for
/// all devices to both broadcast and scan.
///
/// This property lets you customize this behavior, restricting your app to either broadcast or
/// scan.  For example, consider a mobile app that communicates with a set-top box. If the set-top
/// box is programmed to broadcast a pairing code, the mobile app could be set to scan only, to
/// improve latency.
///
/// The default is @c kGNSDiscoveryModeDefault.
@property(nonatomic, readonly) GNSDiscoveryMode discoveryMode;

/// Controls which mediums to use to broadcast and scan pairing codes when discovering nearby
/// devices. See @c discoveryMode for more details about device discovery.
///
/// The default is @c kGNSDiscoveryMediumsDefault.
@property(nonatomic, readonly) GNSDiscoveryMediums discoveryMediums;

/// DEPRECATED - Use GNSBeaconStrategy instead.
/// Search for nearby BLE beacons, along with other nearby devices.
///
/// The default is @c NO. Searching for beacons triggers a location permission dialog from iOS.
@property(nonatomic, readonly) BOOL includeBLEBeacons __attribute__((deprecated));


/// Returns the default strategy, which uses all mediums and is active only in the foreground.
+ (instancetype)strategy;

/// Returns a custom strategy.  You can set any of the optional properties in @c paramsBlock.
+ (instancetype)strategyWithParamsBlock:(void (^)(GNSStrategyParams *))paramsBlock;

@end
