# Project Postmortem: Alx System Engineering & DevOps 0x19

## Incident Overview
During the release of project 0x19 on Alx System Engineering & DevOps, an outage was observed on June 7th at approximately 06:07 GMT. The issue occurred on an isolated Ubuntu 14.04 container running an Apache web server. GET requests to the server resulted in a 500 Internal Server Error instead of displaying the expected HTML file for a simple Holberton WordPress site.

## Debugging Process
### Initial Discovery
The issue was first identified by Sammie on the same day at 19:20 GMT. The following steps were taken to resolve the problem:
1. **Process Verification**: Used `ps aux` to check running processes; confirmed Apache's `root` and `www-data` processes were active.
2. **Configuration Check**: Inspected `/etc/apache2/sites-available` to verify the web server's content source from `/var/www/html/`.
3. **Error Tracing**:
   - Ran `strace` on the root Apache process's PID while executing a curl request. This initial trace did not yield useful information.
   - A subsequent `strace` on the `www-data` process's PID showed a -1 ENOENT (No such file or directory) error attempting to access `/var/www/html/wp-includes/class-wp-locale.phpp`.
4. **File Search and Correction**: 
   - Searched `/var/www/html/` using Vim pattern matching, locating the typo `.phpp` in `wp-settings.php` on line 137.
   - Corrected the typo by removing the extraneous 'p'.

### Resolution
A successful `curl` request post-correction returned a 200 status, confirming the fix. A Puppet manifest (`0-strace_is_your_friend.pp`) was created to automate this correction across deployments.

## Summary
The outage was traced to a typographical error in `wp-settings.php`, where `class-wp-locale.phpp` was incorrectly referenced. The issue was resolved by correcting the file extension to `.php`.

## Prevention and Future Measures
To avoid similar issues:
- **Comprehensive Testing**: Implement thorough pre-deployment testing to catch such errors.
- **Uptime Monitoring**: Utilize services like UptimeRobot for real-time outage alerts.
- **Automation**: The Puppet manifest created will help automate the resolution of similar errors by correcting `.phpp` to `.php` in `/var/www/html/wp-settings.php`.

Note: This manifest ensures the error is unlikely to recur, humorously reminding us that as programmers, we "never make mistakes"! 😉

