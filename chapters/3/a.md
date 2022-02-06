## Design Considerations

One of the larger hurdles towards implementing Kubernetes in a production environment is the suitability of application design. Optimal Kubernetes deployment design changes are more than just the simple containerization of an application. Traditional applications were built and deployed with the expectation of long-term processes and strong interdependence.

The use of **decoupled** resources is integral to Kubernetes. Instead of an application using a dedicated port and socket, for the life of the instance, the goal is for each component to be decoupled from other resources.

Equally important is the expectation of **transience**. Each object should be developed with the expectation that other components will die and be rebuilt. With any and all resources planned for transient relationships to others, we can update versions or scale usage in an easy manner.

In order for the Kubernetes orchestration to work, we need a series of agents, otherwise known as controllers or watch-loops, to constantly monitor the current cluster state and make changes until that state matches the declared configuration.
