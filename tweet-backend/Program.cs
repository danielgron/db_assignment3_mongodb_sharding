using tweet_backend;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("policy",
        builder =>
        {
            builder
            .WithOrigins("http://localhost:4200")
            .AllowAnyHeader()
            .AllowAnyMethod();
        });
});

// Add services to the container.

builder.Services.AddControllers().AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.WriteIndented = true;
    });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.Configure<DatabaseSettings>(
    builder.Configuration.GetSection("TwitterDatabase"));

builder.Services.AddSingleton<TwitterService>();

var app = builder.Build();

    app.UseSwagger();
    app.UseSwaggerUI();

app.UseRouting();

app.UseCors("policy");

app.UseAuthorization();

app.MapControllers();

app.Run();
