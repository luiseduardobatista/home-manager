{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Luís Eduardo Batista";
        email = "luiseduardob303@gmail.com";
      };
    };
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
