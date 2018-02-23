# Tasktracker

Design Considerations:

1. The first page is a user register / Log in, you can log in with email addr.

2. When logged in, there is a feed page for the current user. 

3. In the feed page, current user can design a new task. The owner id is not 
   necessary when creating the new task. Current user could find any user's 
   id by clicking the "List Users".

4. There are also two sections showing tasks assigned to and created by the 
   current user, respectively.

5. A user could only edit the "time_spent" and "is_complete" fields of a task 
   assigned to him. He could not delete such tasks.

6. A user could only edit the "title", "description", and "owner" fields of a 
   task created by himself. He could also delete such tasks.

7. Only a "root" user could delete other users, except itself.



To start your local Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


Deployment on VPS:

1. git clone project to ~/src/ 

2. add "{:distillery, "~> 1.5", runtime: false}" 
   in tasktracker/mix.exs "defp deps do ... end"
   $ mix deps.get

3. $ cd assets && 
   $ npm install --save bootstrap popper.js jquery
   $ npm install --save-dev sass-brunch

4. create DB user (tasktracker) on VPS, remeber its password (pw).
   ( manually move prod.secret.exs file to tasktracker/config/)
   configure DB user and password in prod.secret.exs

   in config/prod.exs, add "server: true," before "load_from_system_env: true"

5. tasktracker@vps:~/src/tasktracker $ MIX_ENV=prod mix ecto.create
   tasktracker@vps:~/src/tasktracker $ MIX_ENV=prod mix ecto.migrate

6. modify the project name to "tasktracker" and port number in deploy.sh 
   and start.sh

7. configure the tasktracker.nginx in sites-available/ and sites-enabled/
   sudo service nginx restart

8. $ mix release.init 
   $ mix release

9. $ ./deploy.sh
   $ ./start.sh


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
