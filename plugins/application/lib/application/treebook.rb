module Redcar
  class Treebook
    include Redcar::Observable
    include Redcar::Model

    attr_reader :trees, :focussed_tree

    def initialize
      @trees = []
      @focussed_tree = nil
    end

    # Add a tree to this treebook
    #
    # @param [Redcar::Tree]
    def add_tree(tree)
      @trees << tree
      @focussed_tree = tree
      notify_listeners(:tree_added, tree)
      tree.focus
      Redcar.app.repeat_event(:tree_added) if Redcar.app
    end

    # Bring the tree to the front
    #
    # @param [Redcar::Tree]
    def focus_tree(tree)
      return if @focussed_tree == tree
      @focussed_tree = tree
      notify_listeners(:tree_focussed, tree)
      tree.focus
    end

    # Remove a tree from this treebook
    #
    # @param [Redcar::Tree]
    def remove_tree(tree)
      if @trees.include?(tree)
        @trees.delete(tree)
        notify_listeners(:tree_removed, tree)
        if tree == focussed_tree
          focus_tree(trees.first) if trees.any?
        end
        Redcar.app.repeat_event(:tree_removed) if Redcar.app
      end
    end

    def switch_down
      if @trees.any?
        if @focussed_tree
          index = @trees.index @focussed_tree
        else
          index = -1
        end
        new_tree_index = index + 1
        new_tree_index = 0 if new_tree_index < 0 or new_tree_index >= @trees.size
        tree = @trees[new_tree_index]
        focus_tree(tree) if tree
      end
    end

    def switch_up
      if @trees.any?
        if @focussed_tree
          index = @trees.index @focussed_tree
        else
          index = 1
        end
        new_tree_index = index - 1
        new_tree_index = @trees.size - 1 if new_tree_index < 0 or new_tree_index >= @trees.size
        tree = @trees[new_tree_index]
        focus_tree(tree) if tree
      end
    end

    private

    # Tell the Treebook that this tree has been focussed in the GUI.
    def set_focussed_tree(tree)
      @focussed_tree = tree
    end
  end
end
