<?php
/**
 * Plugin Name:       Hello (by ROBOTSTXT)
 * Plugin URI:        https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello
 * Description:       Adds a Hello admin page for demonstration purposes.
 * Version:           1.2.0
 * Requires at least: 6.5
 * Requires PHP:      8.2
 * Network:           true
 * Security:          robotstxt@robotstxt.es
 * Author:            ROBOTSTXT
 * Author URI:        https://www.robotstxt.es/
 * Text Domain:       robotstxt-hello
 * Domain Path:       /languages
 * License:           GPL-3.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-3.0.html
 * Gitea Plugin URI:  ROBOTSTXT/robotstxt-hello
 * Gitea Plugin URI:  https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello
 * Plugin ID:         did:plc:7umwjtio3qenfqiai2m5gsgg
 *
 * @package ROBOTSTXT_Hello
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-robotstxt-hello-plugin.php';

( new Robotstxt_Hello_Plugin() )->register();

// Initialize ROBOTSTXT updater (auto-configures from plugin headers).
require_once __DIR__ . '/robotstxt-updater.php';
Robotstxt_Updater::init( __FILE__ );
