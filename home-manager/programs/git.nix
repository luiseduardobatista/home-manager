{
  programs.git = {
    enable = true;
    userName = "Luís Eduardo Batista";
    userEmail = "luiseduardob303@gmail.com";
    includes = [
      {
        condition = "gitdir:~/dev/kyros/";
        contents = {
          user = {
            email = "luisb@kyros.com.br";
          };
        };
      }
      {
        condition = "gitdir:~/dev/pessoal/";
        contents = {
          user = {
            email = "luiseduardob303@gmail.com";
          };
        };
      }
    ];
  };
}
